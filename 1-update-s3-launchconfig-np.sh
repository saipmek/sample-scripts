# set +x

echo "downloading s3 file to Local"
aws s3 cp s3://apiplatform/ocelot/launch-config-scripts/ocelot-launch-config-np.sh ~/Desktop/Projects/ocelot-launch-configs/ocelot-launch-config-np.sh --profile np



OLD_VERSION=$(cat ~/Desktop/Projects/ocelot-launch-configs/ocelot-launch-config-np.sh | grep "$ $ID.dkr.ecr.us-east-1.amazonaws.com/ocelot" | rev | cut -d ":" -f1 | rev)

echo "OLD_VERSION: $OLD_VERSION"

read -p "Enter NEW_VERSION: Ex: v1.12.23: " NEW_VERSION

echo "NEW_VERSION: $NEW_VERSION"

# sed "s/$OLD_VERSION/$NEW_VERSION/g" ~/Desktop/Projects/ocelot-launch-configs/ocelot-launch-config-np.sh

gsed -i'.BAK' "s/$OLD_VERSION/$NEW_VERSION/gI" ~/Desktop/Projects/ocelot-launch-configs/ocelot-launch-config-np.sh

UPDATED_VERSION_VERFICATION=$(cat ~/Desktop/Projects/ocelot-launch-configs/ocelot-launch-config-np.sh | grep "$ID.dkr.ecr.us-east-1.amazonaws.com/ocelot" | rev | cut -d ":" -f1 | rev)

echo "Verify whether the new version is updated?: $UPDATED_VERSION_VERFICATION"

sleep 5

echo "uploading s3 file to AWS"
# cat ~/Desktop/Projects/ocelot-launch-configs/ocelot-launch-config-np.sh
aws s3 cp ~/Desktop/Projects/ocelot-launch-configs/ocelot-launch-config-np.sh s3://apiplatform/ocelot/launch-config-scripts/ocelot-launch-config-np.sh --profile np
