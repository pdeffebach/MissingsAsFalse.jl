# MissingsMacros

Julia macros to make control flow with `missing` values easier. 

    mfalse(e)

Recursively walks through an expression and transforms
`missing` values to `false` in select operations.

Checks for equality, `==`, return `false` in the
presence of `missing`s. `missing == 1` returns
`missing` without the `@mfalse` macro.

Broadcasted checks for equality. `.==` will
return `false` when encountering `missing`s.

`missing` values in `if` or `elseif` conditions
are set to `false`. This also applies to ternary
operations such as `missing == 1 ? 1 : 2`. Without
`@mfalse`, `if-else` conditions error on missing values.

`missing` acts as false in `&&` and `||` control-flow
blocks, which error without `@mfalse`.

In literal indexing operations, i.e. `y[x]`, if
`x` is `<:AbstractVector{Union{Missing, Bool}}`
`missing` values are set to `false` and such indexes
are not returned. Without `@mfalse` such
operations error.

## Examples

```
julia> x = missing;

julia> @mfalse x == 1
false

julia> x = [1, missing]; y = [1, 200];

julia> @mfalse x .== y
2-element BitVector:
 1
 0

julia> @mfalse if x
           100
       else
           200
       end
200

julia> @mfalse (missing && true)
false

julia> @mfalse (missing || true)
true

julia> x = [true, missing, true]; y = [500, 600, 700];

julia> @mfalse y[x]
2-element Vector{Int64}:
 500
 700
```