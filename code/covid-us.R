library(dtw)
library(ape)
library(igraph)

# Read in the data
x <- scan("https://raw.githubusercontent.com/bioinfoacademy/covid-19-us/master/data/time_series_19-covid-Confirmed-us-current.csv", what="", sep="\n")

# Separate elements by one or more whitepace
y <- strsplit(x, ",")

# Extract the first vector element and set it as the list element name
names(y) <- sapply(y, function(x) x[[1]]) # same as above

# Remove column header
y$`Province/State` <- NULL

# Remove the first vector element from each list element
y <- lapply(y, function(x) x[-c(1:5)]) # same as above

# Convert character vectors in list, to numeric vectors
w=lapply(y, as.numeric)

# Cluster using DTW and plot hclust
dm <- dist(w, method= "DTW")
hc <- hclust(dm, method="average")
svg("~/covid-us-dtw-tree.svg")
plot(hc, hang=0.1,cex=0.6)
dev.off()

# Generate igraph
phylo_tree = as.phylo(hc)
graph_edges = phylo_tree$edge
graph_net = graph.edgelist(graph_edges)
myigraph=as.igraph(phylo_tree)
plot(myigraph)
summary(myigraph)

#push igraph to cytoscape
cygraph=createNetworkFromIgraph(myigraph)

#plot all washington cluster data in one
svg("~/covid-us-cluster-trend.svg")
plot(w$Washington,type="l",col="red",xlab="Time Series (Days)", ylab="# Of Confirmed Cases")
lines(w$California,col="green")
lines(w$Massachusetts,col="orange")
lines(w$`New Jersey`,col="purple")
lines(w$Colorado,col="brown")
lines(w$Illinois,col="violet")
lines(w$Georgia,col="black")
lines(w$Florida,col="pink")
lines(w$Louisiana,col="salmon")
lines(w$Michigan,col="magenta")
lines(w$Pennsylvania,col="cyan")
lines(w$Tennessee,col="tan")
lines(w$Texas,col="blue")

legend("bottomleft", 
       legend = c("Washington","California","Massachusetts","New Jersey","Colorado","Illinois","Georgia","Florida","Louisiana","Michigan","Pennsylvania","Tennessee","Texas"), 
       col = c("red","green","orange","purple","brown","violet","black","pink","salmon","magenta","cyan","tan","blue"), 
       pch = c(19), 
       bty = "n", 
       pt.cex = 1, 
       cex = 0.6, 
       text.col = "black", 
       inset = c(0.1, 0.02)
       )
dev.off()
