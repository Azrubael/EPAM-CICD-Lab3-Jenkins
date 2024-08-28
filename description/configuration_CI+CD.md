# 2024-08-28    09:26
=====================

1. Все скрипты 'jenkinsfles/Jenkinsfile*' протестированы

2. Конфигурация multibranch pipeline для 'Jenkinsfile_CD_v5-BuiltIn'
> Jenkins > Dashboard > New Item > Multibranch pipeline >
    > 'Display name': 'CD BuiltIn 27aug2024' >
    > Description: 'Continuous Delivery part of Lab3 EPAM' >
    > Git -- 'Project Repository': 'https://github.com/Azrubael/EPAM-CICD-Lab3-Jenkins.git' >
    > Credentials: '-none-' >
    > Behaviors:
        - Discover branches
        - 'Filter by name (with regular expression)': 'main|dev'
        - Clean before checkout + Delete untracked nested repositories >
    > 'Property strategy': 'All branches get the same properties' >
    > 'Build configuration': 'by Jenkinsfile'
        - jenkinsfiles/Jenkinsfile_CD_v5-BuiltIn >
    > 'Orphaned Item Strategy': 'Discard old items' > *SAVE*

3. Конфигурация pipeline для 'Jenkinsfile_CD2dev_v5-SILVER':
> Jenkins > Dashboard > New Item > Pipeline > 
    > Description: 'Continuous Deployment git branch 'dev' on SILVER node' >
    > Do not allow concurrent builds >
    > 'Build Triggers':
        - 'Build after other projects are built': 'CD BuiltIn 27aug2024/dev' >
    > Pipeline > Definition: 'Pipeline script from SCM' >
        > SCM: Git >
        > 'Repository URL':
            'https://github.com/Azrubael/EPAM-CICD-Lab3-Jenkins.git' >
        > Credentials: '-none-' > Branches to build >
        > 'Branch Specifier (blank for "any")': */dev >
        > 'Script Path': 'jenkinsfiles/Jenkinsfile_CD2dev_v5-SILVER' >
        > Lightweight checkout > *SAVE*

4. Проверка запущенных контейнеров:
    4.1 Для пайпайна ветки dev, 
http://192.168.56.18:3001
# или       
```bash
docker pull azrubael/nodedev:v1.0
docker run --detach --rm \
    --name app-dev-container \
    --publish 3001:3000 \
    azrubael/nodedev:v1.0
```
    4.1 Для пайпайна ветки main
http://192.168.56.18:3000
```bash
docker pull azrubael/nodedev:v1.0
docker run --detach --rm \
    --name app-dev-container \
    --publish 3000:3000 \
    azrubael/nodemain:v1.0
```
