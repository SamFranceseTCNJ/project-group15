Database Creation and Population Instructions:
- 
1. Download all files in repository
2. Create the database:
  
   createdb project

   psql project
   
3. Run the following commands to populate database:
   
    \i projectSchema.sql
   
    \i queries.sql
   
    \q --> to exit the database
   
4. Install python pip, psycopg2, and matplotlib packages with the following commands:
   
   sudo pacman -Syu
   
   sudo pacman -S python-pip python-psycopg2 python-flask

   sudo pacman -S python-matplotlib
   
6. Run the Flask application with the following commands:

   export FLASK_APP=app.py

   flask run
7. Click on the link provided http://127.0.0.1:5000/

End User Usage Instructions: 
-
For question 1: 
1. Pick one of the two traits from the dropdown, adg and lifespan
2. Click submit and the interface will direct you to the page with the data.

For question 2:
1. Enter 2 years in the range of 2012-2023
2. If the years entered are not in that range, the database will default to 2012 and 2023 as the range of years
3. Click submit and the interface will direct you to the page with the data.
4. You could also click all years and get the birthweights for all the years in the database 

To get the male and female birth weights separately: 
1. Pick male avg birth weight or female avg birth weight from the dropdown and click submit.

Queries and Views:
-
- Births: The queries will create a view that will be returning a table of the date of birth of each goat in the database by using the goat id and date of birth

- Deaths: The queries will create a view that will be returning a table of the death date of each goat in the database that has died by using the goat id and checking if the status date of the goat is "dead".

- Lifespan: The queries will create a view that will be returning a table of each goat in the database and their lifespan. 

Screenshots:
- 

<img width="1205" alt="Screenshot 2024-04-30 at 4 26 11 PM" src="https://github.com/TCNJ-degoodj/project-group15/assets/105721424/94897f11-6b05-449e-8642-2722640645b0">



<img width="298" alt="Screenshot 2024-04-30 at 4 27 03 PM" src="https://github.com/TCNJ-degoodj/project-group15/assets/105721424/520359f8-4bf9-46c9-aaa3-61ba0f6b4b2d">



<img width="800" alt="Screenshot 2024-04-30 at 4 27 41 PM" src="https://github.com/TCNJ-degoodj/project-group15/assets/105721424/5db7c8fb-94e9-4b46-8ca5-b53c93cfc8c7">



<img width="690" alt="Screenshot 2024-04-30 at 4 27 57 PM" src="https://github.com/TCNJ-degoodj/project-group15/assets/105721424/357b51dd-de86-4b02-a854-c2957a317623">



<img width="975" alt="Screenshot 2024-04-30 at 4 28 04 PM" src="https://github.com/TCNJ-degoodj/project-group15/assets/105721424/1f1590b6-614b-4542-98cb-1bce2c65a23d">



<img width="479" alt="Screenshot 2024-04-30 at 4 28 21 PM" src="https://github.com/TCNJ-degoodj/project-group15/assets/105721424/1bec4b3a-dd85-4fbd-8776-d1dcfe92f419">



<img width="550" alt="Screenshot 2024-04-30 at 4 28 28 PM" src="https://github.com/TCNJ-degoodj/project-group15/assets/105721424/e48224af-a100-47e2-9f1d-44761aae7fd7">



Collaborators: 
- Julian Ruiz
- Sam Francese
- Saanvi Goyal 
