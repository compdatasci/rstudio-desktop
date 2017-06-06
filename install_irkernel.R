# Based on https://irkernel.github.io/installation/

# Step 1: Installing packages and dependencies via supplied binary packages
update.packages(repos='http://cran.us.r-project.org', ask=FALSE)
install.packages(c('repr', 'IRdisplay', 'evaluate', 'crayon', 'pbdZMQ', 'devtools', 'uuid', 'digest', 'ISwR'), repos='http://cran.us.r-project.org', dependencies = TRUE)
devtools::install_github('IRkernel/IRkernel')

# Step 2: Making the kernel available to Jupyter
IRkernel::installspec(user = FALSE)
