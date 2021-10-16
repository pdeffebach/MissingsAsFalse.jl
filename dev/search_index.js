var documenterSearchIndex = {"docs":
[{"location":"#MissingsAsFalse.jl","page":"Introduction","title":"MissingsAsFalse.jl","text":"","category":"section"},{"location":"","page":"Introduction","title":"Introduction","text":"MissingsAsFalse.jl provides a single macro, @mfalse, which sets treats missing values as false in select operations. These include","category":"page"},{"location":"","page":"Introduction","title":"Introduction","text":"Comparisons, ==, >, <, >=, and <=, as well as their broadcasted equivalents for arrays.\nControl flow, meaning if and elseif, as well as ternary commands, a ? b : c\nShort circuiting compairons, && and ||\nBoolean indexing, y[x] where x is a boolean array which contains missing.","category":"page"},{"location":"","page":"Introduction","title":"Introduction","text":"In Julia, missing values are represents by missing. This is equivalent to NA in R and . in Stata. In Julia, Boolean operations with missing also propagate missing-ness. ","category":"page"},{"location":"","page":"Introduction","title":"Introduction","text":"julia> missing == 1\nmissing","category":"page"},{"location":"","page":"Introduction","title":"Introduction","text":"This is philosophically satisfying. Because missing values represent what we \"don't know\", it makes sense that we \"don't know\" the outcome of a comparison between missing and a known object. But this propagation becomes increasingly burdensome when writing complicated code. In particular, control flow in Julia, like if statements, error on missing values.  ","category":"page"},{"location":"","page":"Introduction","title":"Introduction","text":"julia> if missing == 1\n           println(\"Hello, Earth\")\n       else\n           println(\"Hello, Mars\")\n       end\nERROR: TypeError: non-boolean (Missing) used in boolean context\nStacktrace:\n [1] top-level scope\n   @ REPL[3]:1","category":"page"},{"location":"","page":"Introduction","title":"Introduction","text":"In almost all cases, we want the above statement to print \"Hello, Mars\", instead of throwing an error. ","category":"page"},{"location":"","page":"Introduction","title":"Introduction","text":"Proper handling of missing values requires people to use isequal(missing, 1) instead of missing == 1. The former will return false while the latter will return missing, as shown above. But writing isequal everywhere is burdensome. To help, MissingsAsFalse.jl provides the macro @mfalse. Inside code affected by @mfalse, the Boolean comparisons which normally return missing instead return false. ","category":"page"},{"location":"","page":"Introduction","title":"Introduction","text":"This works on control flow","category":"page"},{"location":"","page":"Introduction","title":"Introduction","text":"julia> @mfalse if missing == 1\n           println(\"Hello, world\")\n       else\n           println(\"Hello, Mars\")\n       end\nHello, Mars","category":"page"},{"location":"","page":"Introduction","title":"Introduction","text":"Greater than and less than comparisons","category":"page"},{"location":"","page":"Introduction","title":"Introduction","text":"julia> x = missing;\n\njulia> @mfalse if x > 100\n           1\n       else\n           100\n       end\n100","category":"page"},{"location":"","page":"Introduction","title":"Introduction","text":"Short-circuiting","category":"page"},{"location":"","page":"Introduction","title":"Introduction","text":"julia> @mfalse x == 1 && true\nfalse\n\njulia> @mfalse x == 1 || true\ntrue","category":"page"},{"location":"","page":"Introduction","title":"Introduction","text":"and boolean indexing","category":"page"},{"location":"","page":"Introduction","title":"Introduction","text":"julia> y = [1, 2, 3, 4];\n\njulia> inds = [true, false, true, missing];\n\njulia> @mfalse y[inds]\n2-element Vector{Int64}:\n 1\n 3","category":"page"},{"location":"","page":"Introduction","title":"Introduction","text":"For complete documentation, see julia> ? @mfalse.","category":"page"},{"location":"api/api/#API","page":"API","title":"API","text":"","category":"section"},{"location":"api/api/","page":"API","title":"API","text":"Modules = [MissingsAsFalse]\nPrivate = false","category":"page"},{"location":"api/api/#MissingsAsFalse.@mfalse-Tuple{Any}","page":"API","title":"MissingsAsFalse.@mfalse","text":"@mfalse(e)\n\nRecursively walks through an expression and transforms missing values to false in select operations.\n\nChecks for equality: ==. @mfalse missing == 1 returns\n\nfalse. Without @mfalse, the expression returns missing.\n\nGreater than and less than comparisons: >, >=, <, and\n\n<=. missing < 1 returns false. Without @mfalse the expression returns missing. The same holds for >=, <, and <=.\n\nBroadcasted comparisons with arrays: .==, .>, .>=, .<, and .<=.\n\nWith @mfalse, all broadcasted comparisons with missing inside collections return false. @mfalse only applies to comparisons with <:AbstractArray{Union{Missing, Bool}}.\n\nControl flow: if and ifelse. With @mfalse, missing\n\nvalues in if or elseif conditions are set to false. This also applies to ternary operations such as missing == 1 ? 1 : 2. Without @mfalse, if-else conditions error on missing values.\n\nShort circuiting. With @mfalse, missing acts as false in\n\n&& and || operations. Without @mfalse, these comparisons error.\n\nIndexing operations: y[x]. In literal indexing operations,\n\ni.e. y[x] (but not getindex), if x is <:AbstractVector{Union{Missing, Bool}} missing values are set to false and such indexes are not returned. Without @mfalse such operations error. Note: @mfalse only applies when x is <:AbstractArray{Union{Missing, Bool}}.\n\nwarning: Warning\nFor array operaions, including braodcasted comparisons (like .==) and boolean indexing y[x] where x is a boolean array with missing values, @mfalse will allocate a new array without missing values. This will allocate memory and may cause noticeable slow-downs.\n\nExamples\n\njulia> x = missing;\n\njulia> @mfalse x == 1\nfalse\n\njulia> x = [1, missing]; y = [1, 200];\n\njulia> @mfalse x .== y\n2-element BitVector:\n 1\n 0\n\njulia> @mfalse if x\n           100\n       else\n           200\n       end\n200\n\njulia> @mfalse (missing && true)\nfalse\n\njulia> @mfalse (missing || true)\ntrue\n\njulia> x = [true, missing, true]; y = [500, 600, 700];\n\njulia> @mfalse y[x]\n2-element Vector{Int64}:\n 500\n 700\n\n\n\n\n\n","category":"macro"}]
}
