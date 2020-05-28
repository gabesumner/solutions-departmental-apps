# Create the demo org
sfdx force:org:create -f config/project-scratch-def.json --setalias departmental-apps --setdefaultusername
#sfdx shane:org:create -f config/project-scratch-def.json -d 30 -s --wait 60 --userprefix admin -o electron.demo

# Push the metadata into the new scratch org.
sfdx force:source:push

# Assign the permset to our user.
sfdx force:user:permset:assign -n electron

# Assign the permset to the Integration user (this will be needed to start the analytics dataflow)
sfdx shane:user:permset:assign -n analytics -g Integration -l User

# Deploy the metadata for the analytics (this needed to happen AFTER the other meta data was pushed)
sfdx force:source:deploy -p dataflow

# Start the dataflow for the Analytics.
sfdx shane:analytics:dataflow:start -n Electron

# Deploy the metadata for the visualizations
sfdx force:source:deploy -p visualization

# Activate the custom theme.
sfdx shane:theme:activate -n Electron

# Set the default password.
sfdx shane:user:password:set -g User -l User -p sfdx1234

# Open the demo org.
sfdx force:org:open



