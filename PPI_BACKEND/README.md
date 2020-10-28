<h1>Server app in Java</h1>

<h2>Database usage</h2>
To use database:<br>
- download and install Docker<br>
- go to PPI/PPI_BACKEND/viroshop directory<br>
- run commend in powershell: <br>
	<b>docker-compose up database</b>
or <b>docker-compose up</b> if you want run pgAdmin also (on 5555 port)<br>
- run backend<br>
<br>
If you want set database not drop every time when backend is launching, comment <b>spring.jpa.hibernate.ddl-auto=create</b> in application.properties file.