<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Register — FindMyClub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/styling.css">
</head>
<body>
    <div class="auth-wrapper">
        <div class="auth-card">
            <div class="auth-logo">Find<em>My</em>Club</div>
            <p class="auth-subtitle">Create your account to get started</p>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger">${error}</div>
            <% } %>

            <form action="${pageContext.request.contextPath}/app/register" method="post">
                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" name="name" placeholder="Jane Smith" required>
                </div>

                <div class="form-group">
                    <label>University Email 
                        <span style="color: var(--gray-500); font-weight: 400;">(must be .edu)</span>
                    </label>
                    <input type="email" name="email" placeholder="yourname@university.edu" required>
                </div>

                <div class="form-group">
                    <label>I am a…</label>
                    <select name="role" required>
                        <option value="student">Student</option>
                        <option value="clubLeader">Club Leader</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Password 
                        <span style="color: var(--gray-500); font-weight: 400;">(min 6 characters)</span>
                    </label>
                    <input type="password" name="password" placeholder="Create a password" required minlength="6">
                </div>

                <div class="form-group">
                    <label>Confirm Password</label>
                    <input type="password" name="confirmPassword" placeholder="Re-enter your password" required>
                </div>

                <button type="submit" class="btn-primary">Create Account</button>
            </form>

            <div class="auth-switch">
                Already have an account? 
                <a href="${pageContext.request.contextPath}/app/login">Sign in</a>
            </div>
        </div>
    </div>
</body>
</html>