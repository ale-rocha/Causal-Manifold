# Instituto Nacional de Astrofisica Optica y Electronica Mx.
# Dep. de Ciencias de la computacion
# Alejandra Rocha Solache

data=read.csv("Outputs/Dataframes/senosoidal_matrix_distances.csv")
d = as.matrix(data)
#ord <- wcmdscale(d,w=rs,k=7, eig=TRUE)
loc <- cmdscale(d)
x <- loc[, 1]
y <- -loc[, 2] # reflect so North is at the top
## note asp = 1, to ensure Euclidean distances are represented correctly
plot(x, y, type = "n", xlab = "", ylab = "", asp = 1, axes = FALSE,
     main = "cmdscale(eurodist)")
text(x, y, rownames(loc), cex = 0.6)

