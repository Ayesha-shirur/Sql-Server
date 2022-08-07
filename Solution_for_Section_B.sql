SECTION B Solution

Use an appropriate combination of SQL, stored procedures and/or triggers to implement the ability to allow programmers to cast a new actor (by ID#) to a movie (by ID#). 

Do not allow actors to be cast more than once for each movie.
Demonstrate that your system works by trying the following.

Cast George Faraday (# 124) in Slumdog Millionaire (# 921).
Cast George Faraday in Back to the Future (# 928).
Cast George Faraday (# 124) in Slumdog Millionaire (# 921)

Record in the script comments what happens with each of these updates and why

Solution : Using stored procedures 
         
         CREATE PROCEDURE cast_actor (@act_ID INTEGER, @mov_ID INTEGER, @roles 
          VARCHAR(50))
          AS
          BEGIN
           INSERT INTO dbo.movie_cast(act_id, mov_ID, role)
           VALUES (@act_id, @mov_ID, @roles);
          END; 
         
Creating Trigger for Do not allow actors to be cast more than once for each movie 
Solution :      
          CREATE TRIGGER cast_actor_trigger 
          ON dbo.movie_cast 
          FOR INSERT 
          AS
          BEGIN 
          declare @mov_id INTEGER;
          declare @act_id INTEGER;
          declare @count INTEGER;
          DECLARE @err_message NVARCHAR(max)
          SET @mov_id = (select mov_id FROM inserted)
          SET @act_id = (select act_id FROM inserted)
          SET @count = (select COUNT(*) FROM movie_cast 
          WHERE mov_id = @mov_id AND act_id = @act_id)
          SELECT act_id, mov_id 
          FROM movie_cast 
          WHERE mov_id = @mov_id 
          IF(@count > 1)
          BEGIN
           SET @err_message = 'Cannot cast actor more than once for the 
          movie'
           RAISERROR(@err_message, 16, 1)
           ROLLBACK
          END
          END;

Demonstrate that your system works by trying the following. 

Cast George Faraday (# 124) in Slumdog Millionaire (# 921). 
Answer : 
          --Cast George Faraday (# 124) in Slumdog Millionaire (# 921) 
          EXECUTE cast_actor 124,921,'George faraday'; 
          
Cast George Faraday in Back to the Future (# 928). 
Answer : 
          --Cast George Faraday in Back to the Future (# 928). 
           EXECUTE cast_actor 124,928,'Back to the Future';

Cast George Faraday (# 124) in Slumdog Millionaire (# 921) 
Answer : 
          --Cast George Faraday (# 124) in Slumdog Millionaire (# 921)
           EXECUTE cast_actor 124,921,'George faraday'; 
       
       
       
       
          
          
          
   
          


