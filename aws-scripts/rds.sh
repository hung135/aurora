#!/bin/bash
#https://docs.aws.amazon.com/cli/latest/reference/rds/create-db-instance.html
#https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.DBInstanceClass.html
aws rds create-db-instance \
--allocated-storage 20 --db-instance-class db.t2.small \
--db-instance-identifier test-instance-maria \
--engine mariadb \
--enable-cloudwatch-logs-exports '["audit","error","general","slowquery"]' \
--no-deletion-protection \
--master-username master --master-user-password secret99

aws rds delete-db-instance \
    --skip-final-snapshot \
    --db-instance-identifier test-instance
    
aws rds create-db-instance \
--allocated-storage 20 --db-instance-class db.t2.small \
--db-instance-identifier test-postgres-instance \
--engine postgres \
--enable-cloudwatch-logs-exports '["postgresql","upgrade"]' \
--no-deletion-protection \
--master-username master --master-user-password secret99

aws rds delete-db-instance \
    --skip-final-snapshot \
    --db-instance-identifier test-postgres-instance