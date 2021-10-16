module MissingsAsFalse

using MacroTools

export @mfalse

"""
    @mfalse(e)

Recursively walks through an expression and transforms
`missing` values to `false` in select operations.

* Checks for equality: `==`. `@mfalse missing == 1` returns
`false`. Without `@mfalse`, the expression returns `missing`.

* Greater than and less than comparisons: `>`, `>=`, `<`, and
`<=`. `missing < 1` returns `false`. Without `@mfalse` the
expression returns `missing`. The same holds for `>=`, `<`, and
`<=`.

* Broadcasted comparisons with arrays: `.==`, `.>`, `.>=`, `.<`, and `.<=`.
With `@mfalse`, all broadcasted comparisons with `missing` inside
collections return `false`. `@mfalse` only applies to comparisons
with `<:AbstractArray{Union{Missing, Bool}}`.

* Control flow: `if` and `ifelse`. With `@mfalse`, `missing`
values in `if` or `elseif` conditions are set to `false`. This
also applies to ternary operations such as `missing == 1 ? 1 : 2`.
Without `@mfalse`, `if-else` conditions error on missing values.

* Short circuiting. With `@mfalse`, `missing` acts as false in
`&&` and `||` operations. Without `@mfalse`, these comparisons
error.

* Indexing operations: `y[x]`. In literal indexing operations,
i.e. `y[x]` (but not `getindex`), if `x` is `<:AbstractVector{Union{Missing, Bool}}`
`missing` values are set to `false` and such indexes
are not returned. Without `@mfalse` such
operations error. Note: `@mfalse` only applies when `x` is
`<:AbstractArray{Union{Missing, Bool}}`.

!!! warning
    For array operaions, including braodcasted comparisons (like `.==`)
    and boolean indexing `y[x]` where x is a boolean array with missing
    values, `@mfalse` will allocate a new array without missing values.
    This will allocate memory and may cause noticeable slow-downs.

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
"""
macro mfalse(e)
    esc(mfalse_helper(e))
end

wrap_coalesce_false(x) = :(coalesce($x, false))
wrap_fix_missing_arr(x) = :(MissingsAsFalse.fix_missing_arr($x))

function fix_missing_arr(v::AbstractArray{Union{Missing, Bool}})
    isequal.(v, true)
end
fix_missing_arr(v) = v

function mfalse_helper(e)
    t = MacroTools.postwalk(e) do x
        !(x isa Expr) && return x
        if x.head == :call
            a1 = x.args[1]
            if (a1 === :(==) ||
                a1 === :> ||
                a1 === :>= ||
                a1 === :< ||
                a1 === :<=)

                wrap_coalesce_false(x)
            elseif (a1 === :.== ||
                    a1 === :.> ||
                    a1 === :.>= ||
                    a1 === :.< ||
                    a1 === :.<=)

                wrap_fix_missing_arr(x)
            else
                x
            end
        elseif (x.head == :if) || (x.head == :elseif)
            x.args[1] = wrap_coalesce_false(x.args[1])
            x
        elseif (x.head === :(&&)) || x.head === :(||)
            x.args[1] = wrap_coalesce_false(x.args[1])
            x.args[2] = wrap_coalesce_false(x.args[2])
            x
        elseif x.head === :ref
            x.args[2:end] .= wrap_fix_missing_arr.(x.args[2:end])
            x
        else
            x
        end
    end
end

end
