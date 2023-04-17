# Get all the instance_ids
# aws ec2 describe-instances --filters "Name=tag:Name,Values=ocelot-svc-np" "Name=instance-state-code,Values=16" --query 'Reservations[*].Instances[*].{Instance:InstanceId}' --output text --profile np > instance_ids.txt

# Get the instance terminate commands
# counter=0
# for instance in `cat instance_ids.txt`
# do
#   counter=$[$counter +1]
#   echo "counter no: $counter"
#   echo "aws autoscaling terminate-instance-in-auto-scaling-group --instance-id $instance --no-should-decrement-desired-capacity --profile np"
# done
echo "total instances: `wc -l < instance_ids.txt`"
counter=0
for instance in `cat instance_ids.txt`
do
  # echo "current instance count is: `wc -l < instance_ids.txt`"
  counter=$[$counter +1]
  echo "-----------$instance no.$counter terminating started--------------"
  aws autoscaling terminate-instance-in-auto-scaling-group --instance-id $instance --no-should-decrement-desired-capacity --profile np
  echo "-----------$instance no.$counter terminating completed------------"
  sleep 300
  echo "-------------waiting for 5 mins complete---------------"
  # if [ $(wc -l < instance_ids.txt) -eq 20 ]
done

echo "------Check the LaunchTime whether all latest------"
aws ec2 describe-instances --filters "Name=tag:Name,Values=ocelot-svc-np" "Name=instance-state-code,Values=16" --query 'Reservations[*].Instances[*].{Instance:InstanceId,LaunchTime:LaunchTime,IP:PrivateIpAddress} | reverse(sort_by([], &LaunchTime))' --output table --profile np
