/*
  Copyright © 2017 Jörg Sommer <joerg@alea.gnuu.de>

  License: MIT https://opensource.org/licenses/MIT
 */

//////
//
// Solution of Euler 87 https://projecteuler.net/problem=87
//
#include <math.h>
#include <stdlib.h>
#include <stdio.h>

static int gen_prime_numbers(uint limit, uint* pn, uint** pn_end)
{
    pn[0] = 2u;
    pn[1] = 3u;
    uint* next_pn = &pn[2];

    for (uint num = *(next_pn - 1) + 2; num <= limit; num += 2)
    {
        for (uint i = (uint)sqrt(num); i >= 3; --i)
        {
            if (num % i == 0)
                goto next;
        }
        if (next_pn >= *pn_end)
            return -1;

        *next_pn++ = num;
    next:
        ;
    }

    *pn_end = next_pn;
    return 0;
}

typedef struct {
    uint* begin;
    uint* end;
    uint* mem_end;
} vector_uint;

static void vector_init(vector_uint* vec)
{
    vec->begin = NULL;
    vec->end = NULL;
    vec->mem_end = NULL;
}

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

static int vector_add(vector_uint* vec, uint el)
{
    if (vec->end >= vec->mem_end)
    {
        uint old_size = (uint)(vec->mem_end - vec->begin);
        size_t new_size = old_size * sizeof(*vec->begin) + (1 << 20);
        vec->begin = realloc(vec->begin, new_size);
        if (vec->begin == NULL)
            return -1;

        vec->mem_end = vec->begin + new_size / sizeof(*vec->begin);
        vec->end = &vec->begin[old_size];
    }

    *vec->end++ = el;
    return 0;
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

    uint* prime_numbers_end = prime_numbers + 4096 / sizeof(*prime_numbers);

    if (gen_prime_numbers((uint)sqrt(LIMIT), prime_numbers, &prime_numbers_end) != 0)
    {
        fprintf(stderr, "Memory for prime numbers exceeded, but more needed.\n");
        return EXIT_FAILURE;
    }

    printf("There are %ld numbers below sqrt(50.000.000)\n",
      prime_numbers_end - prime_numbers);

    vector_uint nums;
    vector_init(&nums);

    for (uint* pn2 = prime_numbers; pn2 < prime_numbers_end; ++pn2)
    {
        uint pow2 = *pn2 * *pn2;

        for (uint* pn3 = prime_numbers; pn3 < prime_numbers_end; ++pn3)
        {
            uint sum = pow2 + *pn3 * *pn3 * *pn3;
            if (sum >= LIMIT)
                break;

            for (uint* pn4 = prime_numbers; pn4 < prime_numbers_end; ++pn4)
            {
                uint pow4 = *pn4 * *pn4;
                pow4 *= pow4;

                uint sum2 = sum + pow4;
                if (sum2 >= LIMIT)
                    break;

                if (vector_add(&nums, sum2) != 0)
                {
                    perror("Failed to increase memory for result numbers");
                    return EXIT_FAILURE;
                }
            }
        }
    }

    qsort(nums.begin, (size_t)(nums.end - nums.begin), sizeof(*nums.begin), cmp_uint);

    uint count = 1;
    for (const uint* n = nums.begin + 1; n < nums.end; ++n)
        if (*(n - 1) != *n)
            ++count;

    printf("Answer: %d\n", count);

    return EXIT_SUCCESS;
}
