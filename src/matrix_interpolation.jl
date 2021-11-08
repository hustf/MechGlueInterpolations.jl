"""
    function_to_interpolated_function(f_xy; physwidth = 10.0m, physheight = 4.0m)

Input: f: (Q, Q)  → (Q, Q) Function taking a tuple quantities, outputs a tuple of quantities
    physwidth:  Q
    physheight: Q

Output: f: (Q, Q)  → (Q, Q) Function taking a tuple quantities, outputs a tuple of quantities

Convert the function f_xy into an interpolated function. The output function is linearly interpolated
between pixels, based on the currently defined sketch scale.

The output of the function can be otherwise; this is just the originally intended use.
"""
function function_to_interpolated_function(f_xy; physwidth = 10.0m, physheight = 4.0m, centered = true)
    # Position iterators
    xs, ys = x_y_iterators_at_pixels(;physwidth, physheight, centered)
    tuplemat = [f_xy(x, y) for x in xs, y in reverse(ys)]
    fxy_inter = interpolate((xs, reverse(ys)),
        tuplemat,
        Gridded(Linear()));
    # Extend the domain, using the same values as on the domain border. Don't know how the closest point
    # on domain boundary is found.
    extrapolate(fxy_inter, Flat())
end


"""
    matrix_to_function(matrix::Matrix, xmin, xmax, ymin, ymax, nx, ny)
    -> f: (Q, Q)  → (Q, Q)

Make a linear interpolation function from (complex) matrix.
This could be useful for e.g. a flow field, where the matrix contains complex
quantity values.

The imaginary component is mapped to the second parameter.
"""
function matrix_to_function(matrix::Matrix, xmin, xmax, ymin, ymax, nx, ny)
    xs = range(xmin, xmax, length = nx)
    ys = range(ymin, ymax, length = ny)
    # Adapt to Interpolations
    tuplemat = map( cmplx -> (real(cmplx), imag(cmplx)), transpose(matrix)[ : , end:-1:1])
    # Function that can interpolate between nodes.
    fxy_inter = interpolate((xs, reverse(ys)),
        tuplemat,
        Gridded(Linear()));
    # Extend the domain, using the same values as on the domain border. Don't know how the closest point
    # on domain boundary is found.
    extrapolate(fxy_inter, Flat())
end


