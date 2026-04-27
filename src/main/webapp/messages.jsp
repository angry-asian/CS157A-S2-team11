<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Messages — FindMyClub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/styling.css">
    <style>
        .msg-layout {
            display: grid;
            grid-template-columns: 280px 1fr;
            gap: 1.2rem;
            height: calc(100vh - 140px);
        }
        @media (max-width: 680px) {
            .msg-layout { grid-template-columns: 1fr; height:auto; }
        }

        /* Sidebar */
        .msg-sidebar {
            background: #fff;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }
        .sidebar-header {
            background: var(--navy);
            color: #fff;
            padding: .9rem 1rem;
            font-weight: 700;
            font-size: .95rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .conv-list { overflow-y: auto; flex: 1; }
        .conv-item {
            padding: .85rem 1rem;
            border-bottom: 1px solid var(--gray-100);
            cursor: pointer;
            text-decoration: none;
            display: block;
            transition: background .12s;
        }
        .conv-item:hover, .conv-item.active { background: var(--gray-50); }
        .conv-item.active { border-left: 3px solid var(--gold); }
        .conv-name { font-weight: 600; color: var(--navy); font-size: .9rem; }
        .conv-preview { font-size: .78rem; color: var(--gray-500); margin-top: .15rem;
                        white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .conv-role { font-size: .72rem; color: var(--gray-300); }

        /* New Message */
        .new-msg-section {
            padding: .8rem 1rem;
            border-top: 1px solid var(--gray-100);
            background: var(--gray-50);
        }
        .new-msg-section select, .new-msg-section button {
            width: 100%; margin-top: .4rem;
            padding: .5rem .7rem; border-radius: 7px;
            font-family: 'DM Sans', sans-serif; font-size: .85rem;
        }
        .new-msg-section select {
            border: 1.5px solid var(--gray-300); color: var(--navy);
        }
        .new-msg-section button {
            background: var(--gold); color: var(--navy-mid);
            border: none; font-weight: 700; cursor: pointer; margin-top: .5rem;
        }
        .new-msg-section button:hover { background: var(--gold-lt); }

        /* Chat Panel */
        .msg-panel {
            background: #fff;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }
        .chat-header {
            background: var(--navy);
            color: #fff;
            padding: .9rem 1.2rem;
            font-weight: 700;
            font-size: .95rem;
        }
        .chat-body {
            flex: 1;
            overflow-y: auto;
            padding: 1rem 1.2rem;
            display: flex;
            flex-direction: column;
            gap: .7rem;
        }
        .bubble-wrap { display: flex; flex-direction: column; }
        .bubble-wrap.mine  { align-items: flex-end; }
        .bubble-wrap.theirs { align-items: flex-start; }
        .bubble {
            max-width: 70%;
            padding: .65rem .95rem;
            border-radius: 16px;
            font-size: .9rem;
            line-height: 1.45;
        }
        .bubble.mine   { background: var(--navy); color: #fff; border-bottom-right-radius: 4px; }
        .bubble.theirs { background: var(--gray-100); color: var(--gray-700); border-bottom-left-radius: 4px; }
        .bubble-time { font-size: .72rem; color: var(--gray-500); margin-top: .2rem; padding: 0 .3rem; }

        .chat-input-area {
            border-top: 1px solid var(--gray-100);
            padding: .9rem 1.2rem;
            display: flex;
            gap: .7rem;
        }
        .chat-input-area textarea {
            flex: 1;
            padding: .6rem .9rem;
            border: 1.5px solid var(--gray-300);
            border-radius: 10px;
            font-family: 'DM Sans', sans-serif;
            font-size: .9rem;
            resize: none;
            height: 56px;
        }
        .chat-input-area textarea:focus {
            outline: none;
            border-color: var(--navy);
        }
        .chat-input-area button {
            padding: 0 1.2rem;
            background: var(--navy);
            color: #fff;
            border: none;
            border-radius: 10px;
            font-weight: 700;
            cursor: pointer;
            font-size: .9rem;
        }
        .chat-input-area button:hover { background: var(--navy-mid); }

        .no-conv {
            flex: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            color: var(--gray-500);
            font-size: .95rem;
            gap: .5rem;
        }
        .no-conv span { font-size: 2.5rem; }
    </style>
</head>
<body>

<nav class="navbar">
    <a class="nav-brand" href="${pageContext.request.contextPath}/app/search">Find<span>My</span>Club</a>
    <div class="nav-links">
        <c:choose>
            <c:when test="${sessionScope.userRole == 'admin'}">
                <a href="${pageContext.request.contextPath}/app/adminDashboard">Admin Panel</a>
            </c:when>
            <c:when test="${sessionScope.userRole == 'clubLeader'}">
                <a href="${pageContext.request.contextPath}/app/clubLeaderDashboard">My Clubs</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/app/studentDashboard">Dashboard</a>
            </c:otherwise>
        </c:choose>
        <a href="${pageContext.request.contextPath}/app/search">Browse Clubs</a>
        <span class="nav-user">💬 ${sessionScope.userName}</span>
        <a href="${pageContext.request.contextPath}/app/logout">Log Out</a>
    </div>
</nav>

<div class="container" style="padding-top:1.2rem;">
    <h1 style="margin-bottom:1rem;font-size:1.4rem;">💬 Messages</h1>

    <div class="msg-layout">

        <!-- Sidebar: Conversations -->
        <div class="msg-sidebar">
            <div class="sidebar-header">
                Conversations
                <span style="font-size:.78rem;font-weight:400;opacity:.8;">${conversations.size()} thread(s)</span>
            </div>

            <div class="conv-list">
                <c:choose>
                    <c:when test="${empty conversations}">
                        <div style="padding:1rem;font-size:.85rem;color:var(--gray-500);">
                            No conversations yet. Start one below!
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="conv" items="${conversations}">
                            <a href="${pageContext.request.contextPath}/app/messages?with=${conv.partner.id}"
                               class="conv-item ${activePartnerId == conv.partner.id ? 'active' : ''}">
                                <div class="conv-name">${conv.partner.name}</div>
                                <div class="conv-role">${conv.partner.role}</div>
                                <c:if test="${not empty conv.lastMessage}">
                                    <div class="conv-preview">${conv.lastMessage.content}</div>
                                </c:if>
                            </a>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- New Conversation -->
            <div class="new-msg-section">
                <div style="font-size:.8rem;font-weight:700;color:var(--navy);margin-bottom:.2rem;">
                    + Start New Conversation
                </div>
                <form action="${pageContext.request.contextPath}/app/sendMessage" method="post">
                    <select name="receiverId" required>
                        <option value="" disabled selected>Select a user…</option>
                        <c:forEach var="u" items="${allUsers}">
                            <c:if test="${u.id != sessionScope.userId}">
                                <option value="${u.id}">${u.name} (${u.role})</option>
                            </c:if>
                        </c:forEach>
                    </select>
                    <input type="text" name="content" placeholder="Type a message…"
                           style="width:100%;margin-top:.4rem;padding:.5rem .7rem;
                                  border:1.5px solid var(--gray-300);border-radius:7px;
                                  font-family:'DM Sans',sans-serif;font-size:.85rem;box-sizing:border-box;"
                           required>
                    <button type="submit">Send</button>
                </form>
            </div>
        </div>

        <!-- Chat Panel -->
        <div class="msg-panel">
            <c:choose>
                <c:when test="${not empty activePartner}">
                    <div class="chat-header">
                        💬 ${activePartner.name}
                        <span style="font-size:.78rem;font-weight:400;opacity:.75;margin-left:.5rem;">
                            ${activePartner.role} · ${activePartner.email}
                        </span>
                    </div>

                    <div class="chat-body" id="chatBody">
                        <c:choose>
                            <c:when test="${empty activeThread}">
                                <div class="no-conv">
                                    <span>👋</span>
                                    Say hello to ${activePartner.name}!
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="msg" items="${activeThread}">
                                    <div class="bubble-wrap ${msg.senderId == sessionScope.userId ? 'mine' : 'theirs'}">
                                        <div class="bubble ${msg.senderId == sessionScope.userId ? 'mine' : 'theirs'}">
                                            ${msg.content}
                                        </div>
                                        <div class="bubble-time">${msg.formattedDate}</div>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="chat-input-area">
                        <form action="${pageContext.request.contextPath}/app/sendMessage"
                              method="post" style="display:contents;">
                            <input type="hidden" name="receiverId" value="${activePartner.id}">
                            <textarea name="content" placeholder="Type a message…"
                                      onkeydown="if(event.key==='Enter'&&!event.shiftKey){event.preventDefault();this.form.submit();}"
                                      required></textarea>
                            <button type="submit">Send</button>
                        </form>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="no-conv">
                        <span>💬</span>
                        Select a conversation or start a new one.
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

    </div>
</div>

<script>
    // Auto-scroll chat to bottom
    var chatBody = document.getElementById('chatBody');
    if (chatBody) chatBody.scrollTop = chatBody.scrollHeight;
</script>

</body>
</html>
