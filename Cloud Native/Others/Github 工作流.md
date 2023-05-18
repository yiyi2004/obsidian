git checkout -b xxx：git checkout xxx是指切换到xxx（用local区的xxx替换disk区文件），-b意味着branch，即创建新分支，这条指令合起来意思是创建并切换到xxx。  
git diff：查看暂存区与disk区文件的差异。  
git add xxx：将xxx文件添加到暂存区。  
git commit：将暂存区内容添加到local区的当前分支中。  
git push *RemoteHostName* *LocalBranchName*：将local区的LocalBranchName分支推送到RemoteHostName主机的同名分支。（若加-f表示无视本地与远程分支的差异强行push）  
git pull *RemoteHostName* *RemoteBranchName*：同上，不过改成从远程主机下载远程分支并与本地同名分支合并。  
git rebase xxx：假设当前分支与xxx分支存在共同部分common，该指令用xxx分支包括common在内的整体替换当前分支的common部分（原先xxx分支内容为common->diversityA，当前分支内容为common->diversityB，执行完该指令后当前分支内容为common->diversityA->diversityB）。  
git branch -D xxx：不加-D表示创建新local分支xxx，加-D表示强制删除local分支xxx。


# branch
![[Pasted image 20221117161444.png]]

![[Pasted image 20221117161510.png]]

![[Pasted image 20221117161610.png]]

- merge 开出自己的分支，然后 merge

![[Pasted image 20221117161629.png]]

![[Pasted image 20221117162109.png]]

![[Pasted image 20221117162414.png]]

- git branch -d dev
- 有人修改了同一个文件

- 更多的需求，进行进一步的学习。


# Pull Request
1. 需要先 fork 一个版本
2. 进入自己项目 fork 的版本，然后 create a pr

![[Pasted image 20221117163253.png]]

![[Pasted image 20221117163344.png]]

- 如果有冲突会显示，要么回去修改，要么重新 fork 然后 pr

![[Pasted image 20221117163453.png]]

![[Pasted image 20221117163600.png]]



# Reference
- [十分钟学会正确的github工作流，和开源作者们使用同一套流程_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV19e4y1q7JJ/?spm_id_from=333.1007.tianma.1-2-2.click&vd_source=25509bb582bc4a25d86d871d5cdffca3)
- [(30) 15★Git入门★制造分支冲突 git conflicts - YouTube](https://www.youtube.com/watch?v=wlUtKDuHN6I&list=PLliocbKHJNwvDp464ktZCsj8h7rXFBE8r&index=15)
