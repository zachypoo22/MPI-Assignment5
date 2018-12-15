# Import the Portal object.
import geni.portal as portal
# Import the ProtoGENI library.
import geni.rspec.pg as pg
import geni.rspec.igext as IG

# Create a portal context.
pc = portal.Context()

# Create a Request object to start building the RSpec.
request = pc.makeRequestRSpec()


tourDescription = \
"""
This profile provides the template for a full research cluster with head node, scheduler, compute nodes, and shared file systems.
First node (head) should contain: 
- Shared home directory using Networked File System
- Management server for SLURM
Second node (metadata) should contain:
- Metadata server for SLURM
Third node (storage):
- Shared software directory (/software) using Networked File System
Remaining three nodes (computing):
- Compute nodes
"""

#
# Setup the Tour info with the above description and instructions.
#  
tour = IG.Tour()
tour.Description(IG.Tour.TEXT,tourDescription)
request.addTour(tour)


link = request.LAN("lan")

for i in range(15):
  if i == 0:
    node = request.XenVM("head")
    node.routable_control_ip = "true"
  elif i == 1:
    node = request.XenVM("metadata")
  elif i == 2:
    node = request.XenVM("storage")
  else:
    node = request.XenVM("compute-" + str(i-2))
    node.cores = 2
    node.ram = 4096
    
  node.disk_image = "urn:publicid:IDN+emulab.net+image+emulab-ops:CENTOS7-64-STD"
  
  iface = node.addInterface("if" + str(i-3))
  iface.component_id = "eth1"
  iface.addAddress(pg.IPv4Address("192.168.1." + str(i + 1), "255.255.255.0"))
  link.addInterface(iface)
  
  node.addService(pg.Execute(shell="sh", command="sudo chmod 755 /local/repository/passwordless.sh"))
  node.addService(pg.Execute(shell="sh", command="sudo /local/repository/passwordless.sh"))
  
    # Ben Walker's solution to address latency
  node.addService(pg.Execute(shell="sh", command="sudo chmod 755 /local/repository/ssh_setup.sh"))
  node.addService(pg.Execute(shell="sh", command="sudo -H -u ab899511 bash -c '/local/repository/ssh_setup.sh'"))
 
  node.addService(pg.Execute(shell="sh", command="sudo su ab899511 -c 'cp /local/repository/source/* /users/ab899511'"))
  
  if i == 0: # head
    #NFS / MPI
    node.addService(pg.Execute(shell="sh", command="sudo chmod 755 /local/repository/setup_head.sh"))
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/setup_head.sh"))
    node.addService(pg.Execute(shell="sh", command="sudo chmod 755 /local/repository/install_mpi.sh"))
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/install_mpi.sh"))
    
    #SLURM
    node.addService(pg.Execute(shell="sh", command="sudo cp /local/repository/source/slurm.conf /usr/local/etc/"))
    node.addService(pg.Execute(shell="sh", command="sudo cp /local/repository/source/cgroup.conf /usr/local/etc/"))
    node.addService(pg.Execute(shell="sh", command="sudo chmod 755 /local/repository/s_install.sh"))
    node.addService(pg.Execute(shell="sh", command="sudo bash /local/repository/s_install.sh"))
    node.addService(pg.Execute(shell="sh", command="sudo /usr/local/sbin/slurmctld"))
    
  elif i == 1: # meta 
    #SLURM
    node.addService(pg.Execute(shell="sh", command="sudo chmod 755 /local/repository/s_install.sh"))
    node.addService(pg.Execute(shell="sh", command="sudo bash /local/repository/s_install.sh"))
    node.addService(pg.Execute(shell="sh", command="sudo cp /local/repository/source/slurmdbd.conf /usr/local/etc/"))
    node.addService(pg.Execute(shell="sh", command="sudo cp /local/repository/source/cgroup.conf /usr/local/etc/"))
    node.addService(pg.Execute(shell="sh", command="sudo systemctl enable mariadb"))
    node.addService(pg.Execute(shell="sh", command="sudo systemctl start mariadb"))
    node.addService(pg.Execute(shell="sh", command="mysql -u root < /local/repository/slurm/sqlSetup.sh"))
    node.addService(pg.Execute(shell="sh", command="sudo /usr/local/etc/slurmdbd"))
    
    
  elif i == 2: # storage
    #NFS / MPI
    node.addService(pg.Execute(shell="sh", command="sudo chmod 755 /local/repository/setup_storage.sh"))
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/setup_storage.sh"))
    
    
    
  else: # compute
    #NFS / MPI
    node.addService(pg.Execute(shell="sh", command="sudo chmod 755 /local/repository/setup_compute.sh"))
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/setup_compute.sh"))
    
    #SLURM
    node.addService(pg.Execute(shell="sh", command="sudo cp /local/repository/source/slurm.conf /usr/local/etc/"))
    node.addService(pg.Execute(shell="sh", command="sudo cp /local/repository/source/cgroup.conf /usr/local/etc/"))
    node.addService(pg.Execute(shell="sh", command="sudo bash /local/repository/slurm_install.sh"))
    node.addService(pg.Execute(shell="sh", command="sudo /usr/local/etc/slurmd"))
   
# Print the RSpec to the enclosing page.
pc.printRequestRSpec(request)
