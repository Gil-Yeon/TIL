# Git

분산버전관리시스템

## SCM&VCS

- SCM(Source Code Management) : (소스)코드 관리 도구
- VCS(Version Control System) : 버전 관리 도구
- DVCS(Distributed Version Control System) : 분산 버전 관리 도구



## Git 명령어

`git [명령어]`

### (1) `git init`

Git으로 코드 관리를 시작

- 코드 관리 단위(기준) : 폴더
- `(master)` : ~~현재 브랜치명~~
- `.git` 폴더 생성 : Git이 관리와 관련된 파일

``` 
$ git init
Initialized empty Git repository in C:/Users/spa84/intro/.git/
```



### (2) `git status`

현재 상태를 출력(Git에게 현재 상태를 물어봄)

- `git init` 직후,

```
$ git status
On branch master
-> master라는 branch위에 있음.

No commits yet
-> 아직 commit이 없음

nothing to commit (create/copy files and use "git add" to track)
-> commit할 것도 없음
```



- `touch a.txt` 파일 추가 후 ,

```
$ git status
On branch master

No commits yet

Untracked files:
  (use "git add <file>..." to include in what will be committed) -> commit하려면 add 해야함
        a.txt
-> 추적되지 않은 파일이 있음
	(파일명)

nothing added to commit but untracked files present (use "git add" to track)
-> commit 하기 위해 add된 것이 없음, 그러나 추적되지 않은 파일은 존재함.
```



- `git add a.txt`직후,

```
$ git status
On branch master

No commits yet

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)
        new file:   a.txt
-> commit 될 변경사항이 있음.
	(파일명)
```



* `git commit` 이후,

```
$ git commit
On branch master
nothing to commit, working tree clean
-> commit 할 게 없어요. 작업 폴더는 깔끔해요.
```



- 파일 수정후,

```
$ git status
On branch master
Changes not staged for commit:
-> commit하기 위해 stage 되지 않은 변경 사항이 있어요.

  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   a.txt

no changes added to commit (use "git add" and/or "git commit -a")
```



### (3) `git add [파일/폴더]`

commit을 위해 파일이나 폴더 stage함.

- `git  add .` : 현재 폴더의 모든 변경 사항 stage

### `git rm --cached [파일/폴더]`



### (4) `git commit -m "커밋메시지"` -> 사진찍는 명령어

> commit ==버전을 생성== 현재상태의 스냅샷 촬영

- 처음으로 commit을 할 경우,

```
$ git commit -m "First commit"
Author identity unknown
-> 작자미상
*** Please tell me who you are.
-> 당신이 누군지 알려주세요.

Run
-> 아래 명령어를 실행하세요.

  git config --global user.email "you@example.com"
  git config --global user.name "Your Name"
```

- `git config ` 설정 후(`vim` 에디터 창),

```
# Please enter the commit message for your changes.
-> 변경사항에 대한 commit message를 입력해주세요.

# Lines starting with '#' will be ignored, and an empty message aborts the commit.
-> #로 시작하는 라인은 무시됩니다. 아무것도 없는 메시지는 종료됩니다.

# On branch master

# Changes to be committed:
#       new file:   test.txt
```



### (5) `git config`

Git에 관한 설정

- `git config --global user.email "이메일"` : global(전역으로) user의 email을 설정
- `git config --global user.email` : 설정값 확인
- `git config --global user.name "이름"`  : global(전역으로) user의 email을 설정
- `git config --global user.name` : 설정값 확인



### (6) `git log`

현재까지의 commit을 출력

- `git log` 출력화면

```
$ git log
commit 52dde35207e0905595a5e108c09b327f58efc7c5 (HEAD -> master)
Author: Gil Yeon <spa362877@gmail.com>
-> 작성자
Date:   Thu Jul 13 17:07:55 2023 +0900
-> 날짜

    Third commit
    -> 커밋메시지
```

- `git log --oneline` : 한줄로 출력

```
$ git log --oneline
52dde35 (HEAD -> master) Third commit
df1cb8d Add b.txt
bffe52e First commit
```



### (7) `git remote`

- `git remote add [저장소이름][저장소주소]` : git remote add origin https://github.com/hkeryfonttlxisdrlw/basic_git
  - git에게 원격저장소(remote) 추가(add)를 명령
- 저장소이름 : `origin`
- 저장소주소 : https://github.com/hkeryfonttlxisdrlw/basic_git

- `git remote -v` : github와의 연결상태를 확인한다.



### (8) `git push`

- `git push [저장소이름][브랜치이름]` : 로컬 저장소의 커밋들을 git hub로 전송하는 데 사용



> add - commit - push

`git add '파일명'`

`git commit -m '커밋메시지'`

`git push [저장소이름] master`

위의 루틴으로 git의 변경사항을 로그에 기록하고 이 로그를 github에 연결하여 관리가 가능하게 한다.



## Git 협업

### (1) `git clone`

- `git clone [주소][파일명]` : 현재 디렉토리에 프로젝트 복사

> 단, git으로 관리되는 디렉토리 아래에 clone하지 않도록 유의

```
$ git clone https://github.com/Ezraelyes/practice-git practice_collab
Cloning into 'practice_collab'...
remote: Enumerating objects: 23, done.
remote: Counting objects: 100% (23/23), done.
remote: Compressing objects: 100% (17/17), done.
remote: Total 23 (delta 9), reused 18 (delta 4), pack-reused 0
Receiving objects: 100% (23/23), done.
Resolving deltas: 100% (9/9), done.
```

### (2) `git pull`

- `git pull [저장소이름][브랜치이름]` : git hub로부터 변경사항을 가져와서 로컬 저장소를 업데이트



> 이후 팀원과 각자 pull-add-commit-push 과정을 거쳐 프로젝트를 나눠서 진행해 볼 수 있다.



### (3) `code`

- `code .` : Visual Studio Code (VS Code) 에디터를 현재 디렉토리에서 실행, VS Code로 현재 디렉토리 기반의 작업을 수행할 때 용이하다.
