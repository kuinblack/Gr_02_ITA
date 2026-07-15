<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<!DOCTYPE html>

<html>

    <head>

        <meta charset="UTF-8">

        <title>EduNexus - Google Login</title>



        <link rel="stylesheet"

              href="<c:url value='/style.css'/>">

    </head>



    <body>



        <div class="login-container">



            <div class="login-card">



                <h2>Choose Google Account</h2>



                <p class="subtitle">

                    Select an account to continue

                </p>



                <form action="<c:url value='/googlelogin'/>" method="get">



                    <button type="submit"

                            class="btn-google"

                            name="email"

                            value="admin@edunexus.com">

                        admin@edunexus.com

                    </button>



                    <br><br>



                    <button type="submit"

                            class="btn-google"

                            name="email"

                            value="sme@edunexus.com">

                        sme@edunexus.com

                    </button>



                    <br><br>



                    <button type="submit"

                            class="btn-google"

                            name="email"

                            value="student1@edunexus.com">

                        student1@edunexus.com

                    </button>



                    <br><br>



                    <button type="submit"

                            class="btn-google"

                            name="email"

                            value="student2@edunexus.com">

                        student2@edunexus.com

                    </button>



                    <br><br>



                    <button type="submit"

                            class="btn-google"

                            name="email"

                            value="student3@edunexus.com">

                        student3@edunexus.com

                    </button>



                    <br><br>



                    <button type="submit"

                            class="btn-google"

                            name="email"

                            value="student4@edunexus.com">

                        student4@edunexus.com

                    </button>



                </form>



                <br>



                <a href="<c:url value='/login'/>" class="back-link">

                    ← Back to Login

                </a>



            </div>



        </div>

    </body>

</html> 

