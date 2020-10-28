<h1>Server app in Java</h1>

<h2>Database usage</h2>
To use database:
- Download and install Docker
- go to PPI/PPI_BACKEND/viroshop directory
- run commend in powershell: 
	<b>docker-compose up database</b>
or <b>docker-compose up</b> if you want run pgAdmin also (on 5555 port)
-run backend

If you want set database not drop every time when backend is launching, comment <b>spring.jpa.hibernate.ddl-auto=create</b> in application.properties file.