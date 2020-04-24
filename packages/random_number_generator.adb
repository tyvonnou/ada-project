with Ada.Numerics.discrete_Random;

package body random_number_generator is

   subtype rand_range is Positive;
   package rand_int is new Ada.Numerics.Discrete_Random(rand_range);

   gen : rand_int.Generator;

   function generate_random_number ( n: in Positive) return Integer is
   begin
      return rand_int.Random(gen) mod n;  -- or mod n+1 to include the end value
   end generate_random_number;

-- package initialisation part
begin
   rand_int.Reset(gen);
end random_number_generator;