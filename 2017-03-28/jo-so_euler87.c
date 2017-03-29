#include <math.h>
#include <stdlib.h>
#include <stdio.h>

static int cmp_uint(const void* p1, const void* p2)
{
    const uint a = *(const uint*)p1;
    const uint b = *(const uint*)p2;
    if (a < b)
        return -1;
    if (a == b)
        return 0;
    return 1;
}

int main(void)
{
    const uint LIMIT = 50000000;
    uint* const prime_numbers = malloc(4096);
    if (prime_numbers == NULL)
    {
        perror("Failed to allocate memory for prime numbers");
        return EXIT_FAILURE;
    }
    uint* const prime_numbers_end = prime_numbers + 4096 / sizeof(*prime_numbers);

    uint max_pn = (uint)sqrt(LIMIT);
    prime_numbers[0] = 2u;
    prime_numbers[1] = 3u;
    uint* next_pn = &prime_numbers[2];

    for (uint num = *(next_pn - 1) + 2; num <= max_pn; num += 2)
    {
        for (uint i = (uint)sqrt(num); i >= 3; --i)
        {
            if (num % i == 0)
                goto next;
        }
        if (next_pn >= prime_numbers_end)
        {
            fprintf(stderr, "Memory for prime numbers exceeded, but more needed.\n");
            return EXIT_FAILURE;
        }

        *next_pn++ = num;
    next:
        ;
    }

    printf("There are %ld numbers below sqrt(50.000.000)\n", next_pn - prime_numbers);

    uint* nums = NULL;
    uint* nums_end = nums;
    uint* next_num = nums;

    for (uint* pn2 = prime_numbers; pn2 < next_pn; ++pn2)
    {
        uint pow2 = *pn2 * *pn2;

        for (uint* pn3 = prime_numbers; pn3 < next_pn; ++pn3)
        {
            uint pow3 = *pn3 * *pn3 * *pn3;

            uint sum = pow2 + pow3;
            if (sum >= LIMIT)
                break;

            for (uint* pn4 = prime_numbers; pn4 < next_pn; ++pn4)
            {
                uint pow4 = *pn4 * *pn4;
                pow4 *= pow4;

                uint sum2 = sum + pow4;
                if (sum2 >= LIMIT)
                    break;

                if (next_num >= nums_end)
                {
                    long next_num_idx = next_num - nums;
                    size_t new_size = (uint)(nums_end - nums) * sizeof(*nums) + (1 << 20);
                    nums = realloc(nums, new_size);
                    if (nums == NULL)
                    {
                        perror("Failed to increase memory for result numbers");
                        return EXIT_FAILURE;
                    }

                    nums_end = nums + new_size / sizeof(*nums);
                    next_num = &nums[next_num_idx];
                }

                *next_num++ = sum2;
            }
        }
    }
    nums_end = next_num;

    qsort(nums, (size_t)(nums_end - nums), sizeof(*nums), cmp_uint);

    uint count = 1;
    for (const uint* n = nums + 1; n < nums_end; ++n)
        if (*(n - 1) != *n)
            ++count;

    printf("Answer: %d\n", count);

    return EXIT_SUCCESS;
}
