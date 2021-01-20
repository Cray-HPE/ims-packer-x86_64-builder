@Library('dst-shared@master') _
 
dockerBuildPipeline {
    app = "ims-packer-x86_64-builder"
    name = "cms-ims-packer-x86_64-builder"
    description = "Cray image management service x86-64 packer image build environment"
    repository = "cray"
    imagePrefix = "cray"
    product = "csm"
    sendEvents = ["IMS"]

    githubPushRepo = "Cray-HPE/ims-packer-x86_64-builder"
    /*
        By default all branches are pushed to GitHub

        Optionally, to limit which branches are pushed, add a githubPushBranches regex variable
        Examples:
        githubPushBranches =  /master/ # Only push the master branch
        
        In this case, we push bugfix, feature, hot fix, master, and release branches
    */
    githubPushBranches =  /(bugfix\/.*|feature\/.*|hotfix\/.*|master|release\/.*)/ 
}
