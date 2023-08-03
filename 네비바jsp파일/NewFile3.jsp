<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.Statement"%>
<%@ page import="java.sql.ResultSet"%>
<%! // 변수 선언
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
    String uid = "admin1";
    String pwd = "1234";
    String url = "jdbc:oracle:thin:@localhost:1521:XE";
    String sql = "SELECT *" + 
                 " FROM game_list ";
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
.ka {
    top: 0;
    background-color: black;
    width: 100%;
    z-index: 9999;
    display: flex;
    margin-left: -8px;
    width: 100%;
    height: 80px;
}

.kategori {
	display: inline-block;
	padding: 10px 20px;
	color: gray;
	font-weight: bold;
	transition: background-color 0.3s; /* 배경색 변경에 대한 트랜지션 효과 설정 */}
	
	#post_searchBox {
    display: flex;
    margin-top: 200px;
    margin-left: 1173px;
}

#post_searchGlass2 {
    height: 41px;
    background-color: rgb(32, 32, 32);
    width: 38px;
    text-align: center;
    padding-top: 22px;
    border-radius:20px;
    position: relative;
    right: -135px;
    bottom: 10px;
    width: 75px;
}

#searchInput {
    background-color: #0c0d16;
    border: none;
    color: white;
    border-radius: 20px;
    background: rgb(32, 32, 32);
    position: relative;
    bottom: 251px;
    left: -1000px;
    width: 200px;
    height: 41px;
}

#suggestionsContainer{
    position: fixed;
    top: 0;
    top:75px;
    left:0px;
    width: 300px;
    right: 8px;
    border: 1px solid black;
    background-color: black;

}

.search-item img {
        max-width: 100px; /* 이미지의 최대 너비 설정 */
        max-height: 100px; /* 이미지의 최대 높이 설정 */
    }
</style>
</head>
<body>
<%
    try {
        // 데이터베이스를 접속하기 위한 드라이버 SW 로드
        Class.forName("oracle.jdbc.driver.OracleDriver");
        // 데이터베이스에 연결하는 작업 수행
        conn = DriverManager.getConnection(url, uid, pwd);
        // 쿼리를 생성하는 객체 생성
        stmt = conn.createStatement();
        // 쿼리 실행
        rs = stmt.executeQuery(sql);
%>
    <body bgcolor='black'>
<div class="ka" >
    <div class="kategori">
        <br>
<div id="post_searchGlass2"></div>
    <div class="search-container"><div id="post_searchBox">
    
        <input type="text" id="searchInput" name="Commu_Search"placeholder="스토어 검색" spellcheck="false" autocomplete="off" class="-input">
<img src="image/1111.png" alt="돋보기" id="dod" class="nnn">
</div>
        <div id="searchResults" class="search-results" style="
        z-index:9000;
    position: relative;
    top: -245px;
    left: 138px;
"></div>
    </div>
    </div>
    <div class="kategori">
        <br>    <div class="change-color" id="kabtn" onmouseover="changeColor(this)" onmouseout="resetColor(this)">탐색</div>
    </div>
    <div class="kategori">
        <br>    <div class="change-color" id="kabtn" onmouseover="changeColor(this)" onmouseout="resetColor(this)">찾아보기</div>
    </div>
    <div class="kategori">
        <br>    <div class="change-color" id="kabtn" onmouseover="changeColor(this)" onmouseout="resetColor(this)">새 소식</div>
    </div>
</div>
    <script>
        function changeColor(element) {
            element.style.color = "white";
        }

        function resetColor(element) {
            element.style.color = "gray";
        }
    </script>
<div id="suggestionsContainer" ></div>

    <script>
        var searchInput = document.getElementById('searchInput');
        var searchResults = document.getElementById('searchResults');
        var visibleResults = 4; // 보여지는 검색 결과 개수

        // 검색어 입력 이벤트 핸들러
        searchInput.addEventListener('input', function() {
            var keyword = this.value;
            showSearchResults(keyword);
        });

        // 검색 결과 표시 함수
        function showSearchResults(keyword) {
            searchResults.innerHTML = '';

            if (keyword.length > 0) {
                // Ajax 요청을 통해 서버로 검색어 전송
                var xhr = new XMLHttpRequest();
                xhr.open('POST', 'SearchServlet.jsp', true);
                xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8');
                xhr.onreadystatechange = function() {
                    if (xhr.readyState === 4 && xhr.status === 200) {
                        var matchedResults = JSON.parse(xhr.responseText);
                        var resultsCount = Math.min(matchedResults.length, visibleResults);

                        if (resultsCount > 0) {
                            for (var i = 0; i < resultsCount; i++) {
                                var item = matchedResults[i];

                                var resultElement = document.createElement('div');
                                resultElement.classList.add('search-item');

                                var thumbnail = document.createElement('img');
                                thumbnail.src = item.thumbnailImg;
                                resultElement.appendChild(thumbnail);

                                var titleElement = document.createElement('span');
                                titleElement.textContent = item.title;
                                resultElement.appendChild(titleElement);

                                resultElement.addEventListener('click', function() {
                                    searchInput.value = item.title;
                                    searchResults.innerHTML = '';
                                });
                                searchResults.appendChild(resultElement);
                            }

                            if (matchedResults.length > visibleResults) {
                                var showMoreLink = document.createElement('a');
                                showMoreLink.textContent = '더보기';
                                showMoreLink.addEventListener('click', function() {
                                    showAllResults(matchedResults);
                                });
                                var showMoreDiv = document.createElement('div');
                                showMoreDiv.classList.add('show-more');
                                showMoreDiv.appendChild(showMoreLink);
                                searchResults.appendChild(showMoreDiv);
                            }
                        } else {
                            var noResultsElement = document.createElement('div');
                            noResultsElement.classList.add('search-no-results');
                            noResultsElement.textContent = '검색 결과 없음';
                            searchResults.appendChild(noResultsElement);
                        }

                        searchResults.classList.add('show');
                    }
                };
                xhr.send('keyword=' + encodeURIComponent(keyword));
            } else {
                searchResults.classList.remove('show');
            }
        }

        // 모든 검색 결과 표시 함수
        function showAllResults(matchedResults) {
            searchResults.innerHTML = '';

            matchedResults.forEach(function(item) {
                var resultElement = document.createElement('div');
                resultElement.classList.add('search-item');

                var thumbnail = document.createElement('img');
                thumbnail.src = item.thumbnailImg;
                resultElement.appendChild(thumbnail);

                var titleElement = document.createElement('span');
                titleElement.textContent = item.title;
                resultElement.appendChild(titleElement);

                resultElement.addEventListener('click', function() {
                    searchInput.value = item.title;
                    searchResults.innerHTML = '';
                });
                searchResults.appendChild(resultElement);
            });
        }
    </script>


  

            
            
<%
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        // 연결된 객체들을 닫는 작업 수행
        if (rs != null)
            try { rs.close(); } catch (Exception e) {}
        if (stmt != null)
            try { stmt.close(); } catch (Exception e) {}
        if (conn != null)
            try { conn.close(); } catch (Exception e) {}
    }
%>
<script>
  function searchGames() {
    var input = document.getElementById('searchInput');
    var filter = input.value;

    var xhr = new XMLHttpRequest();
    xhr.open('GET', 'searchGamesServlet?searchInput=' + encodeURIComponent(filter), true); // 서버 요청을 보내는 URL을 적절히 수정하세요
    xhr.onreadystatechange = function() {
      if (xhr.readyState === 4 && xhr.status === 200) {
        var gameItemsContainer = document.getElementById('gameItemsContainer');
        gameItemsContainer.innerHTML = xhr.responseText;
      }
    };
    xhr.send();
  }
</script>
</body>
</html>