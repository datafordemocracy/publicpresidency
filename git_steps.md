## Git Steps

### First time only

1. In GitHub, fork the repository, https://github.com/datafordemocracy/publicpresidency, to your own github account and go to the forked repository; click on "Clone or Download" and copy the repository URL to the clipboard.

2. In the terminal, navigate to your local directory (where you want the repository to live)

```sh
$ cd "box sync/mpc/datafordemocracy/" # this will be different for you
```

3. Clone the repository locally

```sh
$ git clone https://github.com/mclaibourn/publicpresidency.git # use your GitHub name/url
```

4. Navigate to the new repository

```sh
$ cd publicpresidency
```

5. Tell git about the source repository [(more here)](https://help.github.com/articles/configuring-a-remote-for-a-fork/)

```sh
$ git remote -v # initially only your forked repository should be listed
$ git remote add datademo https://github.com/datafordemocracy/publicpresidency.git # datademo is a name we provided to reference the source repository
$ git remove -v # verify
```

### Working with local files

Before making changes to the files on your local repository, it's probably worth syncing with the source repository first (in case something has changed in the meantime, steps 1-3 below).

Make changes to the forked repository on your local machine; when you're ready to commit those changes (to your forked repository on your local machine).

1. In the terminal, navigate to your local directory

2. List new or modified files available to be committed

```sh
$ git status
$ git diff # show file differnces
```

3. Stage files for commit, then commit

```sh
$ git add [file]
$ git commit -m "[add commit message]"
```

### Syncing local files with forked repository

When you want to add changes from the repository on your local machine to the forked repository on GitHub (the one in your account,
[see more here](https://help.github.com/articles/syncing-a-fork/).

1. In the terminal, navigate to your local directory

2. Fetch the contents of the source repository, datademo

```sh
$ git fetch datademo
$ git checkout master # switch to the master branch on your local repository
```

3. Merge the changes from datademo/master (specified branch) into your local master branch (the current working directory you set above)

```sh
$ git merge datademo/master # this brings your fork's master branch (working directory) in sync with the source repository's master branch)
```

4. Your local copy of the repository is updated; now update your fork on GitHub

```sh
$ git push origin master # pushes the name on your local machine (origin) to a branch on your GitHub page (master)
```

### Make a pull request
When you want to add the changes from your forked repository on GitHub to the source repository

1. Go to source repository on GitHub and click "New pull request"

2. On the compare page, click "compare across forks"; the base fork is the original source repository, the head fork is your fork

3. Give your request a title and description and "Create pull request"
