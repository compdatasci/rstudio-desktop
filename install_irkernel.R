# Based on https://irkernel.github.io/installation/

# Step 1: Installing packages and dependencies via supplied binary packages
install.packages('IRkernel')

# Step 2: Making the kernel available to Jupyter
IRkernel::installspec(user = FALSE)
