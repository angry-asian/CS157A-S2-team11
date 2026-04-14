<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login — FindMyClub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/styling.css">
</head>

<body>
    <div class="auth-wrapper">
        <div class="auth-card">

            <div class="auth-logo">
                Find<em>My</em>Club
            </div>

            <p class="auth-school">
                San José State University
            </p>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger">
                    ${error}
                </div>
            <% } %>

            <% if (request.getAttribute("success") != null) { %>
                <div class="alert alert-success">
                    ${success}
                </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/app/login" method="post">
                
                <div class="form-group">
                    <label for="email">SJSU Email</label>
                    <input 
                        type="email" 
                        id="email"
                        name="email" 
                        placeholder="yourname@sjsu.edu" 
                        required
                    >
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input 
                        type="password" 
                        id="password"
                        name="password" 
                        placeholder="Enter your password" 
                        required
                    >
                </div>

                <button type="submit" class="btn-primary">
                    Sign In
                </button>
            </form>

            <div class="auth-switch">
                Don't have an account?
                <a href="${pageContext.request.contextPath}/app/register">
                    Register here
                </a>
            </div>

            <div style="
                margin-top: 1.5rem;
                padding: 1rem;
                background: var(--gray-50);
                border-radius: 8px;
                font-size: 0.8rem;
                color: var(--gray-500);
                line-height: 1.8;
            ">
                <strong style="color: var(--navy-dark); display: block; margin-bottom: 0.4rem;">
                    Demo accounts:
                </strong>

                <strong style="color: var(--navy);">Student:</strong>
                alice.smith@sjsu.edu / pw1<br>

                <strong style="color: var(--navy);">Student:</strong>
                bob.johnson@sjsu.edu / pw2<br>

                <strong style="color: var(--navy);">Club Leader:</strong>
                frank.garcia@sjsu.edu / pw11<br>

                <strong style="color: var(--navy);">Club Leader:</strong>
                grace.miller@sjsu.edu / pw12<br>

                <strong style="color: var(--navy);">Admin:</strong>
                ivy.martinez@sjsu.edu / pw16
            </div>

        </div>
    </div>
</body>
</html>