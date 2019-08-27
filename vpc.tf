provider "aws" {
    region = "${var.region}"
}

resource "aws_vpc" "DevOps_Test"{
    cidr_block = "${var.vpc_cidr}"
    instance_tenancy = "default"

    tags = {
        Name = "DevOps_Test"
    }
}

#Public Subnets

resource "aws_subnet" "public_subnets"{
    count = "${var.public_count}"
    vpc_id = "${aws_vpc.DevOps_Test.id}"
    cidr_block = "${element(var.public_subnet_cidr,count.index)}"
    availability_zone = "${element(var.public_subnet_azs,count.index)}"

    tags = {
        Name = "public_subnet_${count.index+1}"
    }
}

#Private Subnets

resource "aws_subnet" "private_subnets"{
    count = "${var.private_count}"
    vpc_id = "${aws_vpc.DevOps_Test.id}"
    cidr_block = "${element(var.private_subnet_cidr,count.index)}"
    availability_zone = "${element(var.private_subnet_azs,count.index)}"

    tags = {
        Name = "private_subnet_${count.index+1}"
    }
    
}

#Internet Gateway for the public subnets

resource "aws_internet_gateway" "IGW"{
    vpc_id = "${aws_vpc.DevOps_Test.id}"
    
    tags = {
        Name = "DevOps_Test_IGW"
    }   
}

#Public Route Table
resource "aws_route_table" "public_rt"{
    vpc_id = "${aws_vpc.DevOps_Test.id}"
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.IGW.id}"
    }
    
    tags = {
        Name = "DevOps_Test_public_rt"
    }
}

#Private Route Table

resource "aws_route_table" "private_rt"{
    vpc_id = "${aws_vpc.DevOps_Test.id}"
    
    # route {
    #     cidr_block = "0.0.0.0/0"
    #     gateway_id = "${aws_internet_gateway.IGW.id}"
    # }
    
    tags = {
        Name = "DevOps_Test_private_rt"
    }    
}


#routetable association for public subnets

resource "aws_route_table_association" "public"{
    count = "${var.public_count}"
    subnet_id      = "${element(aws_subnet.public_subnets.*.id, count.index)}"
    route_table_id = "${aws_route_table.public_rt.id}"
}

#routetable association for private subnets

resource "aws_route_table_association" "private"{
    count = "${var.private_count}"
    subnet_id      = "${element(aws_subnet.private_subnets.*.id, count.index)}"
    route_table_id = "${aws_route_table.private_rt.id}"
}

