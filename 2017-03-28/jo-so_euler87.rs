/*
  Copyright © 2017 Jörg Sommer <joerg@alea.gnuu.de>

  License: MIT https://opensource.org/licenses/MIT
 */

//////
//
// Solution of Euler 87 https://projecteuler.net/problem=87
//
fn gen_prime_numbers(limit: u32) -> Vec<u32> {
    let mut ret = vec![2, 3];

    let mut num = *ret.last().unwrap();
    'num: while num + 2 <= limit {
        num += 2;
        for i in 3..((num as f32).sqrt() as u32 + 1) {
            if num % i == 0 {
                continue 'num;
            }
        }
        ret.push(num);
    }

    ret
}

fn main() {
    const LIMIT: u32 = 50_000_000;

    // println!("pn {:?}", gen_prime_numbers(500));
    let pn = gen_prime_numbers((LIMIT as f32).sqrt() as u32);

    println!("There are {} numbers below sqrt(50.000.000)", pn.len());

    let mut nums = Vec::new();

    for pn4 in pn.iter() {
        let pow4 = pn4.pow(4);
        if pow4 >= LIMIT {
            break;
        }

        for pn3 in pn.iter() {
            let sum = pow4 + pn3.pow(3);
            if sum >= LIMIT {
                break;
            }

            for pn2 in pn.iter() {
                let sum2 = sum + pn2.pow(2);
                if sum2 >= LIMIT {
                    break;
                }

                nums.push(sum2);
            }
        }
    }

    nums.sort();
    nums.dedup();

    println!("Answer {}", nums.len());
}
