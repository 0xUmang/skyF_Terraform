# skyF_Terraform

This exercise automates the provisioing of EC2 instances with some custom identified usecases

1. Creates Security Groups independently
2. Creates EC2 instance as per the suppiled and needed variables. Each EC2 Instance for this exercise would get an EBS volume created and it would be attached to that particular EC2.
3. Creates a seperate management layer of NICs with the EC2 which is attached after the EC2 is created and not at the boot time 