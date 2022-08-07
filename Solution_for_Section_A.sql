SECTION A Solution 

1. Write a query in SQL to list the Horror movies
Solution : 
          CREATE CLUSTERED INDEX IX_Movie_Genres 
          ON dbo.movie_genres(gen_id,mov_id); 
          CREATE NONCLUSTERED INDEX IX_Genres 
          ON dbo.genres(gen_title,gen_id);
          SELECT
           m.mov_title AS 'Movie_Title',
           g.gen_title AS 'Genre_Title'
          FROM dbo.movie m 
          JOIN dbo.movie_genres mg 
           ON m.mov_id=mg.mov_id 
          JOIN dbo.genres g 
           ON mg.gen_id=g.gen_id 
          WHERE
           g.gen_title='Horror'; 


2. Write a query in SQL to find the name of all reviewers who have rated 8 or more stars
Solution : 
          CREATE CLUSTERED INDEX IX_Rating 
          ON dbo.rating(rev_id, mov_id);
          CREATE NONCLUSTERED INDEX IX_Rating_Stars 
          ON dbo.rating(rev_stars)
          INCLUDE(rev_id, mov_id);
          SELECT 
           rv.rev_name as ‘Reviewers_Name’
          FROM dbo.reviewer rv 
          JOIN dbo.rating ra 
           ON ra.rev_id=rv.rev_id 
          WHERE ra.rev_stars>=8 
          AND rv.rev_name!='';

3. Write a query in SQL to list all the information of the actors who played a role in the movie ‘Deliverance’.
Solution : 
          CREATE CLUSTERED INDEX IX_Movie_Cast
          ON dbo.movie_cast(mov_id,act_id);
          CREATE NONCLUSTERED INDEX IX_Movie_Title 
          ON dbo.movie(mov_title);
          SELECT 
           a.act_id 'Actor Id'
          , a.act_fname +' '+ a.act_lname 'Full Name'
          , a.act_gender 'Gender'
          FROM dbo.actor a 
          JOIN dbo.movie_cast mc 
           ON a.act_id=mc.act_id 
          JOIN dbo.movie m 
           ON mc.mov_id=m.mov_id 
          WHERE mov_title='Deliverance'; 


4. Write a query in SQL to find the name of the director (first and last names) who directed a movie that casted a role for 'Eyes Wide Shut'. (using subquery)
Solution : 
          CREATE NONCLUSTERED INDEX IX_Movie_Id_Title 
          ON dbo.movie(mov_title)
          INCLUDE(mov_id);
          CREATE NONCLUSTERED INDEX IX_Movie_Cast_Id_Role 
          ON dbo.movie_cast([role]);
          CREATE CLUSTERED INDEX IX_Movie_Direction 
          ON dbo.movie_director(dir_id);
          SELECT dir_fname 'First Name', dir_lname 'Last Name'
          FROM dbo.director 
          WHERE dir_id IN (
          SELECT dir_id 
          FROM dbo.movie_director 
          WHERE mov_id IN(
           SELECT mov_id 
           FROM movie_cast WHERE role IN (
           SELECT role 
           FROM dbo.movie_cast 
           WHERE mov_id = (
           SELECT mov_id 
          FROM dbo.movie 
          WHERE mov_title='Eyes Wide Shut'
           )
           )
          )
          );
          
5. Write a query in SQL to find the movie title, year, date of release, director and 
actor for those movies which reviewer is ‘Neal Wruck’
Solution :
          CREATE NONCLUSTERED INDEX IX_Reviewer_Name 
          ON dbo.reviewer(rev_name);
          SELECT m.mov_title AS 'Movie_Title',
           m.mov_year AS 'Movie_Year',
          CONVERT(DATE,m.mov_dt_rel) AS 'Date_of_Release',
           d.dir_fname + ' ' + d.dir_lname AS 'Director_Name',
           a.act_fname + ' ' + a.act_lname AS 'Actor_Name'
          FROM Movie m 
          INNER JOIN movie_director md 
          ON m.mov_id = md.mov_id 
          INNER JOIN director d 
          ON d.dir_id = md.dir_id 
          INNER JOIN movie_cast mc 
          ON mc.mov_id = md.mov_id 
          INNER JOIN Actor a 
          ON a.act_id = mc.act_id 
          INNER JOIN rating r 
          ON r.mov_id = m.mov_id 
          WHERE r.rev_id IN (
          SELECT rev_id from Reviewer 
          WHERE rev_name = 'Neal Wruck'
          );

6. Write a query in SQL to find all the years which produced at least one movie and that received a rating of more than 4 stars. 
Solution :
          SELECT m.mov_year
          FROM dbo.movie m 
          JOIN dbo.rating ra 
          ON m.mov_id=ra.mov_id 
          WHERE ra.rev_stars>4; 

7. Write a query in SQL to find the name of all movies who have rated their ratings with a NULL value
Solution :
          SELECT m.mov_title 'Title'
          FROM dbo.movie m 
          JOIN dbo.rating ra 
          ON m.mov_id=ra.mov_id 
          WHERE ra.rev_stars IS NULL; 

8. Write a query in SQL to find the name of movies who were directed by ‘David’
Solution : 
          CREATE NONCLUSTERED INDEX IX_Director_Name
          ON dbo.director(dir_fname,dir_lname);
          SELECT m.mov_title 'Movie Name'
          FROM dbo.movie m 
          JOIN dbo.movie_director md 
          ON m.mov_id=md.mov_id 
          JOIN dbo.director d 
          ON d.dir_id=md.dir_id 
          WHERE d.dir_fname='David'; 

9. Write a query in SQL to list the first and last names of all the actors who were cast in the movie ‘Boogie Nights’, and the roles they played in that production.
Solution :
          SELECT a.act_fname 'First_Name'
          , a.act_lname 'Last_Name'
          , mc.role AS 'Role'
          FROM dbo.actor a 
          JOIN dbo.movie_cast mc 
          ON mc.act_id=a.act_id 
          JOIN dbo.movie m 
          ON m.mov_id=mc.mov_id 
          WHERE m.mov_title='Boogie Nights';

10.Find the name of the actor who have worked in more than one movie.
Solution : 
          SELECT a.act_id, a.act_fname + ' ' + a.act_lname 'Full Name'
          FROM dbo.actor a 
          JOIN (
          SELECT act_id, count(*) 'c'
          FROM dbo.movie_cast 
          GROUP BY act_id 
          ) t1 
          ON t1.act_id=a.act_id 
          AND t1.c > 1
