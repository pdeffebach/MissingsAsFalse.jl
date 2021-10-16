# MissingsAsFalse.jl

MissingsAsFalse.jl provides a single macro, `@mfalse`, which sets treats `missing` values as false in select operations. These include

* Comparisons, `==`, `>`, `<`, `>=`, and `<=`, as well as their broadcasted equivalents for arrays.
* Control flow, meaning `if` and `elseif`, as well as ternary commands, `a ? b : c`
* Short circuiting compairons, `&&` and `||`
* Boolean indexing, `y[x]` where `x` is a boolean array which contains `missing`.

In Julia, missing values are represents by `missing`. This is equivalent to `NA` in R and `.` in Stata. In Julia, Boolean operations with `missing` also propagate `missing`-ness. 

```julia
julia> missing == 1
missing
```

This is philosophically satisfying. Because `missing` values represent what we "don't know", it makes sense that we "don't know" the outcome of a comparison between `missing` and a known object. But this propagation becomes increasingly burdensome when writing complicated code. In particular, control flow in Julia, like `if` statements, error on `missing` values.  

```julia
julia> if missing == 1
           println("Hello, Earth")
       else
           println("Hello, Mars")
       end
ERROR: TypeError: non-boolean (Missing) used in boolean context
Stacktrace:
 [1] top-level scope
   @ REPL[3]:1
```

In almost all cases, we want the above statement to print `"Hello, Mars"`, instead of throwing an error. 

Proper handling of `missing` values requires people to use `isequal(missing, 1)` instead of `missing == 1`. The former will return `false` while the latter will return `missing`, as shown above. But writing `isequal` everywhere is burdensome. To help, MissingsAsFalse.jl provides the macro `@mfalse`. Inside code affected by `@mfalse`, the Boolean comparisons which normally return `missing` instead return `false`. 

This works on control flow

```julia
julia> @mfalse if missing == 1
           println("Hello, world")
       else
           println("Hello, Mars")
       end
Hello, Mars
```

Greater than and less than comparisons

```julia
julia> x = missing;

julia> @mfalse if x > 100
           1
       else
           100
       end
100
```

Short-circuiting

```julia
julia> @mfalse x == 1 && true
false

julia> @mfalse x == 1 || true
true
```

and boolean indexing

```julia
julia> y = [1, 2, 3, 4];

julia> inds = [true, false, true, missing];

julia> @mfalse y[inds]
2-element Vector{Int64}:
 1
 3
```

For complete documentation, see `julia> ? @mfalse`.