# Create the demo org (uncomment for local development)
# sfdx force:org:delete -u departmental-apps
# sfdx force:org:create -f config/project-scratch-def.json --setalias departmental-apps --setdefaultusername

# Create the demo org (uncomment for the SFDX scratch org deployer)
sfdx shane:org:create -f config/project-scratch-def.json -d 30 -s --wait 60 --userprefix admin -o electron.demo

# Push the metadata into the new scratch org.
sfdx force:source:push

# Assign the permset to the default admin user.
sfdx force:user:permset:assign -n electron

# Assign a special analytics permset to the Integration User used by Einstein Analytics
sfdx shane:user:permset:assign -n analytics -g Integration -l User

# Import the data required by the demo
sfdx automig:load --inputdir ./data --deletebeforeload

# Deploy the metadata for the the dataflow (this needed to happen AFTER the other meta data was pushed and the permset was applied to the Integration user)
sfdx force:source:deploy -p dataflow

# Start the dataflow for the Analytics.
sfdx shane:analytics:dataflow:start -n Electron

# Deploy the metadata for the Einstein Analytics visualizations (this will only deploy after the dataflow has run)
sfdx force:source:deploy -p visualizations

# Activate the custom theme.
sfdx shane:theme:activate -n Electron

# Set the default password.
sfdx shane:user:password:set -g User -l User -p sfdx1234

# Open the demo org.
sfdx force:org:open