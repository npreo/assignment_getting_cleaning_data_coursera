#assignment getting and cleaning data

#set working directory (not shown for privacy) and read files

x_train<-read.table("X_train.txt")
y_train<-read.table("y_train.txt")

x_test<-read.table("X_test.txt")
y_test<-read.table("y_test.txt")

#union train e test set

train<-cbind(x_train,y_train)
test<-cbind(x_test,y_test)
wear<-rbind(train,test)

#select mean and std variables
feat<-read.table("features.txt")
i1<-grep("mean()", feat[,2], fixed = TRUE)
i2<-grep("std()", feat[,2], fixed = TRUE)
ind<-union(i1,i2)
ind<-c(ind,ncol(wear))
wear<-wear[,ind]

# add activity and variables' labels
names(wear)[length(wear)]<-"activity"
act<-read.table("activity_labels.txt")
wear$activity<-factor(wear$activity, labels = as.character(act[,2]))
nam<-as.character(feat[ind,2])
nam[length(nam)]<-"activity"
colnames(wear)<-nam

#add subject's column
sub_train<-read.table("subject_train.txt")
sub_test<-read.table("subject_test.txt")
subject<-rbind(sub_train, sub_test)
dataset<-cbind(wear,subject)
names(dataset)[ncol(dataset)]<-"subject"

#prepare and save tydy dataset
dataset$activity<-as.factor(dataset$activity)
dataset$subject<-as.factor(dataset$subject)
library(reshape2)        

new_data <- dcast(melt(dataset, id = c("subject", "activity")), 
                       subject+activity ~ variable, mean)

write.table(new_data, "tidy_data.txt", row.names = FALSE, quote = FALSE)        

