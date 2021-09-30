-- Triggers




use Library




-- 1.1


CREATE OR ALTER TRIGGER tr1dot1
ON S_Cards
INSTEAD OF INSERT
AS
BEGIN
  SET NOCOUNT ON
  DECLARE @scid int
  DECLARE @IsExistsBook bit
  SELECT @scid = Id_Book FROM inserted
  IF(EXISTS(
  SELECT
  *FROM Books
  WHERE
  Books.Id=@scid
  ))
  BEGIN
    PRINT 'Insert successfully'
    declare @BookId int
    select @BookId=Id_Book from inserted
    declare @CardId int
    select @CardId=Id from inserted
    declare @StudId int
    select @StudId=Id_Student from inserted
    declare @DateOut datetime
    select @DateOut=inserted.DateOut from inserted
    declare @DateIn datetime
    select @DateIn=inserted.DateIn from inserted
    declare @LibId int
    select @LibId=inserted.Id_Lib from inserted
    INSERT INTO Library.dbo.S_Cards (Id,Id_Student,[Id_Book],[DateOut],[DateIn],[Id_Lib])
    VALUES
    (@CardId, @StudId, @BookId,@DateOut, @DateIn, @LibId)
  END
  ELSE
  BEGIN
    print 'Error'
    ROLLBACK TRANSACTION
  END
END




select *from S_Cards


INSERT INTO Library.dbo.S_Cards
(Id,Id_Student,[Id_Book],[DateOut],[DateIn],[Id_Lib])
VALUES
(1111, 11, 99,CAST(N'2001-04-21 00:00:00.000' AS DateTime), CAST(N'2001-06-12 00:00:00.000' AS DateTime), 2)







-- 1.2


CREATE OR ALTER TRIGGER tr1dot2
ON T_Cards
INSTEAD OF INSERT
AS
BEGIN
  SET NOCOUNT ON
  DECLARE @scid int
  DECLARE @IsExistsBook bit
  SELECT @scid = Id_Book FROM inserted
  IF(EXISTS(
  SELECT
  *FROM Books
  WHERE
  Books.Id=@scid
  ))
  BEGIN
    PRINT 'Insert successfully'
    declare @BookId int
    select @BookId=Id_Book from inserted
    declare @CardId int
    select @CardId=Id from inserted
    declare @TeachdId int
    select @TeachdId=Id_Teacher from inserted
    declare @DateOut datetime
    select @DateOut=inserted.DateOut from inserted
    declare @DateIn datetime
    select @DateIn=inserted.DateIn from inserted
    declare @LibId int
    select @LibId=inserted.Id_Lib from inserted
    INSERT INTO Library.dbo.T_Cards (Id,Id_Teacher,[Id_Book],[DateOut],[DateIn],[Id_Lib])
    VALUES
    (@CardId, @TeachdId, @BookId,@DateOut, @DateIn, @LibId)
  END
  ELSE
  BEGIN
    print 'Error'
    ROLLBACK TRANSACTION
  END
END




select *from T_Cards




INSERT INTO Library.dbo.T_Cards
(Id,Id_Teacher,[Id_Book],[DateOut],[DateIn],[Id_Lib])
VALUES
(133, 5, 3,CAST(N'2001-04-21 00:00:00.000' AS DateTime), CAST(N'2001-06-12 00:00:00.000' AS DateTime), 2)




-- 2.1


CREATE OR ALTER TRIGGER tr2dot1
ON Books
After Update
AS
BEGIN
  SET NOCOUNT ON
   declare @StudentsId int
   declare @BookId int
   SELECT @BookId = Id FROM inserted
   SELECT @StudentsId = Id FROM inserted
   IF(EXISTS
	(
     Select *
     from
     Library.dbo.Students 
     Inner Join Library.dbo.S_Cards
     ON
     Library.dbo.Students.Id=Library.dbo.S_Cards.Id_Student
     Inner Join Library.dbo.Books
     ON
     Library.dbo.Books.Id=Library.dbo.S_Cards.Id_Book
     Where 
     Library.dbo.Students.Id=@StudentsId
	 AND
	 Library.dbo.Books.Id=@BookId
    )
    )
	BEGIN
	  IF(EXISTS
	  (
	  Select
	  count(*)
      from
      Library.dbo.Students 
      Inner Join Library.dbo.S_Cards
      ON
      Library.dbo.Students.Id=Library.dbo.S_Cards.Id_Student
      Inner Join Library.dbo.Books
      ON
      Library.dbo.Books.Id=Library.dbo.S_Cards.Id_Book
	  where
      Library.dbo.Students.Id=@StudentsId
      AND 
      Library.dbo.Books.Id=@BookId
	  group by      
	  Library.DBO.Students.Id
	  Having 
	  COUNT(*)>0
	  )
	  )
	  BEGIN
	    PRINT 'GOOD'
	  END
	  ELSE
	  BEGIN 
	    print 'Error'
        ROLLBACK TRANSACTION
	  END
	END
END





   declare @StudentsId_ int
   set @StudentsId_=17
   declare @BookId_ int
   set @BookId_=2
   IF(@StudentsId_>0)
	 BEGIN
	   UPDATE Library.dbo.Books
       SET Library.dbo.Books.Quantity = Library.dbo.Books.Quantity+1
       WHERE 
	   Library.dbo.Books.Id=@BookId_
	   AND
	   Library.dbo.Books.Quantity>0
	END




     Select *
     from
     Library.dbo.Books




-- 2.2


CREATE OR ALTER TRIGGER tr2dot2
ON Books
After Update
AS
BEGIN
  SET NOCOUNT ON
   declare @TeachersId int
   declare @BookId int
   SELECT @BookId = Id FROM inserted
   SELECT @TeachersId = Id FROM inserted
   IF(EXISTS
	(
     Select *
     from
     Library.dbo.Teachers 
     Inner Join Library.dbo.T_Cards
     ON
     Library.dbo.Teachers.Id=Library.dbo.T_Cards.Id_Teacher
     Inner Join Library.dbo.Books
     ON
     Library.dbo.Books.Id=Library.dbo.T_Cards.Id_Book
     Where 
     Library.dbo.Teachers.Id=@TeachersId
	 AND
	 Library.dbo.Books.Id=@BookId
    )
    )
	BEGIN
	  IF(EXISTS
	  (
	  Select
	  count(*)
      from
      Library.dbo.Teachers 
      Inner Join Library.dbo.T_Cards
      ON
      Library.dbo.Teachers.Id=Library.dbo.T_Cards.Id_Teacher
      Inner Join Library.dbo.Books
      ON
      Library.dbo.Books.Id=Library.dbo.T_Cards.Id_Book
	  where
      Library.dbo.Teachers.Id=@TeachersId
      AND 
      Library.dbo.Books.Id=@BookId
	  group by      
	  Library.DBO.Teachers.Id
	  Having 
	  COUNT(*)>0
	  )
	  )
	  BEGIN
	    PRINT 'GOOD'
	  END

	END
    ELSE
	 BEGIN 
	    print 'Error'
        ROLLBACK TRANSACTION
	 END
END




   declare @TeachersId_ int
   set @TeachersId_=2
   declare @BookId_ int
   set @BookId_=2
   IF(@TeachersId_>0)
   BEGIN
     UPDATE Library.dbo.Books
     SET Library.dbo.Books.Quantity = Library.dbo.Books.Quantity+1
     WHERE 
     Library.dbo.Books.Id=@BookId_
     AND
     Library.dbo.Books.Quantity>0
   END
	



	 Select *
     from
     Library.dbo.Books




-- 3.1


CREATE OR ALTER TRIGGER tr2dot1
ON Books
After Update
AS
BEGIN
  SET NOCOUNT ON
   declare @StudentsId int
   declare @BookId int
   SELECT @BookId = Id FROM inserted
   SELECT @StudentsId = Id FROM inserted
   IF(EXISTS
	(
     Select *
     from
     Library.dbo.Students 
     Inner Join Library.dbo.S_Cards
     ON
     Library.dbo.Students.Id=Library.dbo.S_Cards.Id_Student
     Inner Join Library.dbo.Books
     ON
     Library.dbo.Books.Id=Library.dbo.S_Cards.Id_Book
     Where 
     Library.dbo.Students.Id=@StudentsId
	 AND
	 Library.dbo.Books.Id=@BookId
    )
    )
	BEGIN
	  IF(EXISTS
	  (
	  Select
	  count(*)
      from
      Library.dbo.Students 
      Inner Join Library.dbo.S_Cards
      ON
      Library.dbo.Students.Id=Library.dbo.S_Cards.Id_Student
      Inner Join Library.dbo.Books
      ON
      Library.dbo.Books.Id=Library.dbo.S_Cards.Id_Book
	  where
      Library.dbo.Students.Id=@StudentsId
      AND 
      Library.dbo.Books.Id=@BookId
	  group by      
	  Library.DBO.Students.Id
	  Having 
	  COUNT(*)>0
	  )
	  )
	  BEGIN
	    PRINT 'GOOD'
	  END
	END
    ELSE
	 BEGIN 
	    print 'Error'
        ROLLBACK TRANSACTION
	 END
END




   declare @StudentsId_ int
   set @StudentsId_=17
   declare @BookId_ int
   set @BookId_=2
   IF(@StudentsId_>0)
   BEGIN
     UPDATE Library.dbo.Books
     SET Library.dbo.Books.Quantity = Library.dbo.Books.Quantity-1
     WHERE 
     Library.dbo.Books.Id=@BookId_
     AND
     Library.dbo.Books.Quantity>0
   END




-- 3.2


CREATE OR ALTER TRIGGER tr3dot2
ON Books
After Update
AS
BEGIN
  SET NOCOUNT ON
   declare @TeachersId int
   declare @BookId int
   SELECT @BookId = Id FROM inserted
   SELECT @TeachersId = Id FROM inserted
   IF(EXISTS
	(
     Select *
     from
     Library.dbo.Teachers 
     Inner Join Library.dbo.T_Cards
     ON
     Library.dbo.Teachers.Id=Library.dbo.T_Cards.Id_Teacher
     Inner Join Library.dbo.Books
     ON
     Library.dbo.Books.Id=Library.dbo.T_Cards.Id_Book
     Where 
     Library.dbo.Teachers.Id=@TeachersId
	 AND
	 Library.dbo.Books.Id=@BookId
    )
    )
	BEGIN
	  IF(EXISTS
	  (
	  Select
	  count(*)
      from
      Library.dbo.Teachers 
      Inner Join Library.dbo.T_Cards
      ON
      Library.dbo.Teachers.Id=Library.dbo.T_Cards.Id_Teacher
      Inner Join Library.dbo.Books
      ON
      Library.dbo.Books.Id=Library.dbo.T_Cards.Id_Book
	  where
      Library.dbo.Teachers.Id=@TeachersId
      AND 
      Library.dbo.Books.Id=@BookId
	  group by      
	  Library.DBO.Teachers.Id
	  Having 
	  COUNT(*)>0
	  )
	  )
	  BEGIN
	    PRINT 'GOOD'
	  END
	END
    ELSE
	 BEGIN 
	    print 'Error'
        ROLLBACK TRANSACTION
	 END
END




   declare @TeachersId_ int
   set @TeachersId_=2
   declare @BookId_ int
   set @BookId_=2
   IF(@TeachersId_>0)
   BEGIN
     UPDATE Library.dbo.Books
     SET Library.dbo.Books.Quantity = Library.dbo.Books.Quantity-1
     WHERE 
     Library.dbo.Books.Id=@BookId_
     AND
     Library.dbo.Books.Quantity>0
   END
	




Select *
from
Library.dbo.Books




-- 4


CREATE OR ALTER TRIGGER tr4
ON S_Cards
AFTER INSERT
AS
BEGIN
  declare @BookId int
  select @BookId=Id_Book from inserted
  declare @CardId int
  select @CardId=Id from inserted
  declare @StudId int
  select @StudId=Id_Student from inserted
  declare @DateOut datetime
  select @DateOut=inserted.DateOut from inserted
  declare @DateIn datetime
  select @DateIn=inserted.DateIn from inserted
  declare @LibId int
  select @LibId=inserted.Id_Lib from inserted
  IF(EXISTS(
	  Select
	  count(*)
      from
      Library.dbo.S_Cards 
      Inner Join Library.dbo.Students
      ON
      Library.dbo.Students.Id=Library.dbo.S_Cards.Id_Student
      Inner Join Library.dbo.Books
      ON
      Library.dbo.Books.Id=Library.dbo.S_Cards.Id_Book
	  where
      Library.dbo.Students.Id=@StudId
      AND 
      Library.dbo.Books.Id=@BookId
	  group by      
	  Students.Id
	  Having 
	  COUNT(*)>3
  ))
  BEGIN
      print 'Error'
    ROLLBACK TRANSACTION
  END
  IF(EXISTS(
	  Select
	  count(*)
      from
      Library.dbo.S_Cards 
      Inner Join Library.dbo.Students
      ON
      Library.dbo.Students.Id=Library.dbo.S_Cards.Id_Student
      Inner Join Library.dbo.Books
      ON
      Library.dbo.Books.Id=Library.dbo.S_Cards.Id_Book
	  where
      Library.dbo.Students.Id=@StudId
      AND 
      Library.dbo.Books.Id=@BookId
	  group by      
      Students.Id
	  Having 
	  COUNT(*)<3
  ))
  BEGIN
    PRINT 'GOOD'
  END
END




Select *
from
Library.dbo.S_Cards




INSERT INTO Library.dbo.S_Cards (Id,Id_Student,[Id_Book],[DateOut],[DateIn],[Id_Lib])
VALUES
(1123, 17, 16,CAST(N'2001-06-21 00:00:00.000' AS DateTime), CAST(N'2001-08-12 00:00:00.000' AS DateTime), 2)




-- 5


CREATE OR ALTER TRIGGER tr5
ON S_Cards
After INSERT
AS
BEGIN
  declare @BookId int
  select @BookId=Id_Book from inserted
  declare @CardId int
  select @CardId=Id from inserted
  declare @StudId int
  select @StudId=Id_Student from inserted
  declare @DateOut datetime
  select @DateOut=inserted.DateOut from inserted
  declare @DateIn datetime
  select @DateIn=inserted.DateIn from inserted
  declare @LibId int
  select @LibId=inserted.Id_Lib from inserted  
  IF(EXISTS(
  Select*
  from
  Library.dbo.S_Cards
  where
  Library.dbo.S_Cards.DateIn=@DateIn
  AND
  Library.dbo.S_Cards.DateOut=@DateOut
  )
  )
  BEGIN
   IF(EXISTS(
   Select*
   from
   Library.dbo.S_Cards
   Inner Join
   Library.dbo.Students
   ON
   Students.Id=S_Cards.Id_Student
   Inner Join
   Library.dbo.Books
   ON
   Books.Id=S_Cards.Id_Book
   where
   Library.dbo.S_Cards.DateIn=@DateIn
   AND
   Library.dbo.S_Cards.DateOut=@DateOut
   AND
   Library.dbo.Students.Id=@StudId
   AND
   DATEPART(month,Library.dbo.S_Cards.DateOut)-DATEPART(month,Library.dbo.S_Cards.DateIn)<2
  )
  )
  Begin
    PRINT ' Good =>' +' Student Id '+ CAST(@StudId as nvarchar(max))+' Book Id '+ CAST(@BookId as nvarchar(max)) +' Book Day out '+CAST( DATEPART(month,@DateOut) as nvarchar(max)) +' Book Day in '+CAST( DATEPART(month,@DateIn) as nvarchar(max)) 
  END
  ELSE
  Begin
    PRINT ' Error =>' +' Student Id '+ CAST(@StudId as nvarchar(max))+' Book Id '+ CAST(@BookId as nvarchar(max)) +' Book Day out '+CAST( DATEPART(month,@DateOut) as nvarchar(max)) +' Book Day in '+CAST( DATEPART(month,@DateIn) as nvarchar(max)) 
    ROLLBACK TRANSACTION
  END
  END
END




Select 
*from
Library.dbo.S_Cards




INSERT INTO Library.dbo.S_Cards
(Id,Id_Student,[Id_Book],[DateOut],[DateIn],[Id_Lib])
VALUES
(185, 2, 11,CAST(N'2001-12-21 00:00:00.000' AS DateTime), CAST(N'2001-11-12 00:00:00.000' AS DateTime), 2)




-- 6


CREATE TABLE Library.dbo.LibDeleted 
(
Id int primary key IDENTITY (1,1) NOT NULL,
Id_DeletedBook int
)




CREATE OR ALTER TRIGGER tr6
ON Books
INSTEAD OF DELETE
AS
BEGIN
  declare @BookId int
  select @BookId=Id from deleted
    IF(EXISTS(
    Select*
    from
    Books
	where
	Books.Id=@BookId
    )
    )
    BEGIN
	  PRINT 'Good'
	  	DELETE FROM Books WHERE Books.Id=@BookId;
        Insert into LibDeleted(Id_DeletedBook)
        values(@BookId)
    END
	ELSE
	  BEGIN
	    PRINT 'Error'
	    ROLLBACK TRANSACTION
	  END
END




    declare @id as int
	set @id = 1
	DELETE FROM Books WHERE Books.Id=@id;
    Insert into LibDeleted(Id_DeletedBook)
    values(@id)
    DELETE FROM LibDeleted
    WHERE ID NOT IN
    (
        SELECT MAX(ID) AS MaxRecordID
        FROM LibDeleted
        GROUP BY Id_DeletedBook
    );


	 
	 
    select * from Books
	select * from LibDeleted
