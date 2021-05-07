#!/bin/bash


#echo "$(git branch -a)"


SUB1='remotes/origin/'
SUB2='remotes/origin/tags'
SUB3='trunk'


echo "Please enter the SVN server url: "
read SVN_URL

echo 'Username of Bitbucket'
read username
echo 'Password of Bitbucket'
read password  # -s flag hides password text
echo 'Please specify the Project Key'
read project_key

# echo "Please Provide the Bitbucket url: "
# # read GIT_URL
# read GIT_URL

echo "Phase 1 Done----------------------------------------------------------------------------"


#Creating the authors file and cloning
svn checkout $SVN_URL
svn log -q $SVN_URL | awk -F '|' '/^r/ {sub("^ ", "", $2); sub(" $", "", $2); print $2" = "$2" <"$2">"}' | sort -u > authors.txt

#svn log -q https://svn.riouxsvn.com/cms_system | awk -F '|' '/^r/ {sub("^ ", "", $2); sub(" $", "", $2); print $2" = "$2" <"$2"@novartis.com>"}' | sort -u > authors.txt

svn log --stop-on-copy $SVN_URL
git svn clone -r1:HEAD --no-minimize-url --stdlayout --no-metadata --authors-file authors.txt $SVN_URL
echo "CLONED and Syncronised--------------------------------------------------------------------"





#Creating the Bitbucket Repository
FOLD_PATH=$(echo $SVN_URL| cut -d'/' -f 4)



echo "$username"
echo "$password"
echo "$FOLD_PATH"
echo "$project_key"


#Bitbucket Cloud
#curl -X POST -v -u $username:$password "https://api.bitbucket.org/2.0/repositories/$username/$FOLD_PATH" -H "Content-Type: application/json" -d '{"scm": "git", "is_private": "true", "fork_policy": "no_public_forks", "project": {"key": "'$project_key'"}}'

#Bitbucket Server/Data center version - 4.4
#curl -u $username:$password -X POST -H "Content-Type:application/json" -d '{"name": "'$reponame'","scmId": "git","forkable": true}' http://localhost:7990/rest/api/1.0/projects/$product_key/repos

echo "Created Bitbucket Repository-----------------------------------------------------------------"





# #Adding the remote origin path
cd $FOLD_PATH


git remote add origin https://$username@bitbucket.org/$username/$FOLD_PATH.git
git config credential.helper store




util_branches ()
{

git push origin master
for eachBranch in $(git branch -a)
do
  if [[ ("$eachBranch" == *"$SUB1"* ) && ( "$eachBranch" != *"$SUB2"*) && ( "$eachBranch" != *"$SUB3"*) ]]; then
    SUBSTRING=$(echo $eachBranch| cut -d'/' -f 3)
    echo "$SUBSTRING"
    git checkout -b $SUBSTRING origin/$SUBSTRING
    git push origin $SUBSTRING
    
  fi
done
}

util_tags ()
{

git tag 
for eachTag in $(git branch -a)
do
  if [[ ("$eachTag" == *"$SUB2"* )]]; then
    SUBSTRING=$(echo $eachTag| cut -d'/' -f 4)
    echo "$SUBSTRING"
    git checkout origin/tags/$SUBSTRING
    git tag -a $SUBSTRING -m "CREATING TAG $SUBSTRING"
    git push origin master $SUBSTRING
    
  fi
done
}


util_branches 
echo "All branches pushed--------------------------------------------------"
util_tags
echo "All tags pushed------------------------------------------------------"
