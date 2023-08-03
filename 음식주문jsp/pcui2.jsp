<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>


<!DOCTYPE html>
<html>
<head>
<title>PC방 음식 주문</title>
<meta charset="UTF-8">

<link rel="stylesheet" href="css/pcui2.css" />
<script>
        // 장바구니 관련 코드
        var cartItems = [];

        function addToCart(foodNo, foodName, foodPrice) {
            var quantityElement = document.getElementById("quantity_" + foodNo);
            var quantity = parseInt(quantityElement.value);

            if (quantity > 0) {
                var item = {
                    foodNo: foodNo,
                    foodName: foodName,
                    foodPrice: foodPrice,
                    quantity: quantity
                };

                var index = findCartItemIndex(foodNo);
                if (index !== -1) {
                    cartItems[index].quantity += quantity;
                } else {
                    cartItems.push(item);
                }

                updateCart();
                quantityElement.value = 1;
            }
        }

        function findCartItemIndex(foodNo) {
            for (var i = 0; i < cartItems.length; i++) {
                if (cartItems[i].foodNo === foodNo) {
                    return i;
                }
            }
            return -1;
        }


        function updateCart() {
            var cartItemsElement = document.getElementById("cartItems");
            cartItemsElement.innerHTML = "";

            var totalAmount = 0; // 총 가격을 저장할 변수 추가

            if (cartItems.length === 0) { // 장바구니가 비어있는 경우
                var emptyCartMessage = document.createElement("p");
                emptyCartMessage.textContent = "장바구니가 비어 있습니다.";
                cartItemsElement.appendChild(emptyCartMessage);

                totalAmount = 0; // 총 가격을 0원으로 설정
            } else {
                for (var i = 0; i < cartItems.length; i++) {
                    var item = cartItems[i];

                    var li = document.createElement("li");
                    li.textContent = item.foodName + " - " + item.foodPrice * item.quantity + "원 ";

                    totalAmount += item.foodPrice * item.quantity; // 총 가격 계산

                    var quantitySpan = document.createElement("span");
                    quantitySpan.textContent = item.quantity;
                    quantitySpan.setAttribute("style", "float: right;    line-height: 40px; ");
                    
                    var decreaseButton = document.createElement("button");
                    decreaseButton.textContent = "-";
                    decreaseButton.setAttribute("onclick", "decreaseQuantity(" + i + ")");
                    decreaseButton.setAttribute("style", "margin-top: 5px;float: right; width: 23.8px;background: white;   height: 30px;color: red;margin-left: 10px;margin-right: 10px;");

                    var increaseButton = document.createElement("button");
                    increaseButton.textContent = "+";
                    increaseButton.setAttribute("onclick", "increaseQuantity(" + i +")");
                    increaseButton.setAttribute("style", "margin-top: 5px; float: right; background: white;  height: 30px;color: blue;margin-left: 10px;margin-right: 10px;");
                   
                    
                    
                    var removeButton = document.createElement("button");
                    removeButton.textContent = "X";
                    removeButton.setAttribute("onclick", "removeFromCart(" + i + ")");
                    removeButton.setAttribute("style", "height: 30px;line-height: 40px;color: black;float: right;background: white;border: 1px solid white;");
                    
                    li.appendChild(removeButton);
                    li.appendChild(increaseButton);
                    li.appendChild(quantitySpan);
                    li.appendChild(decreaseButton);
                    cartItemsElement.appendChild(li);
                }
            }

            // 총 가격을 표시하는 요소에 총 가격을 설정
            var totalAmountElement = document.getElementById("totalPrice");
            if (totalAmountElement) {
                totalAmountElement.textContent = "총 가격: " + totalAmount + "원";
            }
        }

        function decreaseQuantity(index) {
            var item = cartItems[index];
            if (item.quantity > 1) {
                item.quantity--;
                updateCart();
            }
        }

        function increaseQuantity(index) {
            var item = cartItems[index];
            item.quantity++;
            updateCart();
        }

        function removeFromCart(index) {
            cartItems.splice(index, 1);
            updateCart();
        }

        // 카테고리 필터링 코드
        function filterTable(category) {
            var table = document.getElementById("foodTable");
            var rows = table.getElementsByTagName("tr");

            for (var i = 1; i < rows.length; i++) {
                var row = rows[i];
                var rowCategory = row.getAttribute("data-category");

                if (category === "all" || rowCategory === category) {
                    row.style.display = "";
                } else {
                    row.style.display = "none";
                }
            }
        }


        function saveCartItemsToDatabase() {
            var xhr = new XMLHttpRequest();
            var url = "saveCartItems.jsp";
            var cartItemsJson = JSON.stringify(cartItems); // 장바구니 데이터를 JSON 문자열로 변환

            xhr.open("POST", url, false);
            xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");

            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4) {
                    if (xhr.status === 200) {
                        console.log(xhr.responseText);
                    } else {
                        console.error("Error: " + xhr.status);
                    }
                }
            };

            xhr.send("cartItems=" + encodeURIComponent(cartItemsJson)); // JSON 문자열을 인코딩하여 전송
        }

        function clearCart() {
            cartItems = []; // 장바구니 배열을 비움
            updateCart(); // 장바구니 업데이트

            // 추가로 데이터베이스에도 장바구니를 비우는 요청을 보낼 수 있습니다.
            saveCartItemsToDatabase();
        }

        window.onload = function () {
            updateCart();
        };

        function handleClick() {
          	if((cartItems.length == 0) ){
          		 alert("주문을 다시해주세요.");
          	}
          	else{
          		saveCartItemsToDatabase();
                alert("주문이 완료되었습니다.");
           
          	}
        }
        
    </script>


<script>


        function showMenu(menuId) {
            // 모든 메뉴 숨기기
            var menus = document.getElementsByClassName("menu2");
            for (var i = 0; i < menus.length; i++) {
                menus[i].style.display = "none";
            }

            // 선택한 메뉴 보이기
            var menu = document.getElementById(menuId);
            menu.style.display = "block";
        }

 

        function showOrderHistory() {
            var orderHistoryContainer = document.getElementById("order-history");
            orderHistoryContainer.innerHTML = "";

            for (var i = 0; i < cartItems.length; i++) {
                var item = document.createElement("li");
                item.textContent = cartItems[i];
                orderHistoryContainer.appendChild(item);
            }

            var modal = document.getElementById("order-history-modal");
            modal.style.display = "block";
        }

        function closeOrderHistory() {
            var modal = document.getElementById("order-history-modal");
            modal.style.display = "none";
        }
    </script>
</head>
<body>


	<div class="main">
		<div class="main1">
			<div class="Adv">

				<div class="Adv-item">
					<font color="#FFFF00">
						<div id="advertisement-container">
							<div class="advertisement" style="background-color: #24242C;">
								<h2 style="line-height: 2;">[3월 이벤트] 맛있게 맵다! 활활 불타는 닭갈비 라이스
									메뉴가 출시되었습니다.</h2>
							</div>
							<div class="advertisement" style="background-color: #24242C;">
								<h2 style="line-height: 2;">[3월 이벤트] PC방 시간 10시간당 음료 한잔 무료!</h2>
							</div>
							<div class="advertisement" style="background-color: #24242C;">
								<h2 style="line-height: 2;">[3월 이벤트] 음식 한 개 시킬 때마다 PC방 1시간
									적립!</h2>
							</div>
						</div>
					</font>
				</div>
			</div>

			<div class="nav">
				<div class="slider">
					<div class="templates">

						<button class="category-button" onclick="filterTable('all')">전체</button>
						<button class="category-button" onclick="filterTable('0')">분식</button>
						<button class="category-button" onclick="filterTable('1')">탄산음료</button>
						<button class="category-button" onclick="filterTable('2')">라면</button>
						<button class="category-button" onclick="filterTable('3')">카페음료</button>
						<button class="category-button" onclick="filterTable('4')">한식</button>


					</div>
				</div>

				<div class="nav-item">
					<div class="search">
						<input type="text" class="my-input" placeholder="상품명 검색">
					</div>
					<div class="search">
						<i class="fas fa-search"></i>
					</div>
					<div class="plus-option">
						<i class="fas fa-keyboard"></i> <i class="fas fa-microphone"></i>
					</div>
				</div>
			</div>

		</div>
	</div>
	<div class="scrollable">
		<table id="foodTable"
			style="position: relative; left: 5px; margin-left: 5px;">
			<tr>
			</tr>
			<%-- 데이터베이스 연결 및 데이터 조회 --%>
			<%
				request.setCharacterEncoding("utf-8");
			String uid = "admin1";
			String pwd = "1234";
			String url = "jdbc:oracle:thin:@localhost:1521:XE?useUnicode=true&characterEncoding=UTF-8";

			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			try {
				Class.forName("oracle.jdbc.driver.OracleDriver");
				conn = DriverManager.getConnection(url, uid, pwd);

				String sql = "SELECT food_no, food_name, food_price, food_img, food_category FROM cafe_food";
				pstmt = conn.prepareStatement(sql);
				rs = pstmt.executeQuery();

				while (rs.next()) {
					String foodNo = rs.getString("food_no");
					String foodName = rs.getString("food_name");
					int foodPrice = rs.getInt("food_price");
					String foodImg = rs.getString("food_img");
					String foodCategory = rs.getString("food_category");
			%>
			<%
				int count = 0;
			while (rs.next()) {
				if (count % 5 == 0) {
			%>
			<tr data-category="<%=rs.getString("food_category")%>">
				<%
					}
				%>

				<th>
					<p>
						<img src="<%=rs.getString("food_img")%>" alt="Food Image"
							style="width: 200px; height: 150px;"><br>
					</p>
					<div class="hidden-content">
						<p><%=rs.getString("food_name")%></p>
						<p><%=rs.getInt("food_price")%>원
						</p>
						<input type="hidden" id="quantity_<%=rs.getString("food_no")%>"
							value="1" min="1">
						<button class="hidden-button" value="1"
							onclick="addToCart('<%=rs.getString("food_no")%>', '<%=rs.getString("food_name")%>', <%=rs.getInt("food_price")%>)">
							<h3>담기</h3>
						</button>
					</div>
				</th>

				<%
					count++;
				if (count % 5 == 0) {
				%>
			</tr>
			<%
				}
			}
			%>



			<%
				}
			} catch (Exception e) {
			e.printStackTrace();
			} finally {
			if (rs != null) {
			try {
				rs.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
			}
			if (pstmt != null) {
			try {
				pstmt.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			}
			if (conn != null) {
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			}
			}
			%>
		</table>
	</div>



	<div class="main2">
		<div class="Adv2"
			style="top: 8px; /* left: 1059px; */ position: relative; top: -944px; left: 1050px;">

			<div class="pc-item">
				<font color="#FFFF00"> &emsp;PC.No. 089</font>
			</div>
			<div class="pc-item">
				<font color="#FFFF00" size=5> &ensp;김유신 님</font>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;
				&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;
				<button button id="btntn" onclick="clearCart()">비우기</button>
				<div id="order-history-modal">
					<div id="order-history-content">

						<span class="close" onclick="closeOrderHistory()">&times;</span>
						<h2>주문 내역</h2>
						<ul id="order-history"></ul>
					</div>
				</div>



				<!-- 주문내역 모달 -->
				<div id="order-history-modal" style="display: none;">
					<div id="order-history-content">
						<span onclick="closeOrderHistory()" class="close">&times;</span>
						<h2>주문내역</h2>
						<ul id="order-history"></ul>
					</div>
				</div>

			</div>


			<div class="scrollable2"
				style="background-color: white; width: 480px; height: 300px; margin-left: 10px;">


				<ul id="cartItems" style="list-style: none;"></ul>
				<ul id="cart-list"></ul>
			</div>

			</ul>
			</font><br>
		</div>

		<div class="container3">
			&emsp;
			&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;
			&emsp;&emsp;&emsp;&emsp;&emsp; <font size=5> </font>

		</div>


		<script>
        displayCartItems(); // 초기에 바구니에 담긴 상품 목록을 화면에 표시
    </script>
		<div class="n"
			style="position: relative; bottom: 1451px; left: 1053px;">
			<div class="paytext2">
				&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;
				&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;<font size=5>
					<div id="totalPrice"></div>
				</font>
			</div>
			<br>

			<div class="paytext3">
				<img
					src="https://ssl.pstatic.net/melona/libs/1446/1446105/083d802530094a6acf3c_20230525161957518.jpg"
					width="482" height="40">
			</div>
			<div class="pc-item">
				<font color="white" size=4 style="margin-left: 7px; margin-top:15px; margin-bottom:10px;">결제정보&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;
					&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;<input type='radio'
					name='pay' value='first' onclick='checkOnlyOne(this)' /> 선불 <input
					type='radio' name='pay' value='last'
					onclick='checkOnlyOne(this)' /> 후불
				</font>
			</div>



			<div class="pay-item">

				<button class="button6" id="cashButton">현금</button>
				<button class="button6" id="creditButton">신용카드</button>
				<button class="button6" id="couponButton">쿠폰</button>
			</div>
			<br>
			<div class="pay-item3">
				<font color=white>&emsp; <input type='radio' name='pay3'
					value='a' onclick='checkOnlyThree(this)' /> 5만원권 &emsp;&emsp;<input
					type='radio' name='pay3' value='b'
					onclick='checkOnlyThree(this)' /> 1만원권 &emsp;&emsp;<input
					type='radio' name='pay3' value='b'
					onclick='checkOnlyThree(this)' /> 5천원권&emsp;&emsp; <input
					type='radio' name='pay3' value='b'
					onclick='checkOnlyThree(this)' /> 1천원권 <br><input
					type='radio' name='pay3' value='b'style="
    margin-left: 13px;
    margin-top: 20px;
"
					onclick='checkOnlyThree(this)' /> 금액에 맞게
					&emsp;&emsp;&emsp;&emsp;&emsp; <input type='radio' name='pay3'
					value='right' onclick='checkOnlyThree(this)' /> 직접입력 <input
					type='text' id='textbox2' style='width: 100px' disabled /> <!-- 텍스트박스를 비활성화 상태로 생성 -->

					<script>
						
					        // 버튼 클릭 시 처리 함수
					     function handleButtonClick(event) {
    const buttons = document.getElementsByClassName("button6");
    
    // 클릭된 버튼이 이미 활성화된 상태인지 확인
    const isActive = event.target.classList.contains("active");
    
    // 모든 버튼의 활성화 클래스 제거
    for (let i = 0; i < buttons.length; i++) {
        buttons[i].classList.remove("active");
    }
    
    // 클릭된 버튼이 이미 활성화된 상태이면 종료
    if (isActive) {
        return;
    }
    
    // 클릭된 버튼에 활성화 클래스 추가
    event.target.classList.add("active");
}

// 버튼 클릭 이벤트 핸들러 등록
const cashButton = document.getElementById("cashButton");
const creditButton = document.getElementById("creditButton");
const couponButton = document.getElementById("couponButton");

cashButton.addEventListener("click", handleButtonClick);
creditButton.addEventListener("click", handleButtonClick);
couponButton.addEventListener("click", handleButtonClick);

function showMenu(menuId) {
    // 모든 메뉴 숨기기
    var menus = document.getElementsByClassName("menu2");
    for (var i = 0; i < menus.length; i++) {
        menus[i].style.display = "none";
    }

    // 선택한 메뉴 보이기
    var menu = document.getElementById(menuId);
    menu.style.display = "block";
}
  window.onload = function() {
    var chickenImage = document.querySelector('.jb-b');
    chickenImage.addEventListener('mouseover', function() {
      chickenImage.src = 'data:image/jpeg;base64,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';
    });
    chickenImage.addEventListener('mouseout', function() {
      chickenImage.src = 'data:image/png;base64,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';
    });
  };
const advertisements = document.querySelectorAll('.advertisement');
let currentAdIndex = 0;

setInterval(() => {
  // 현재 광고 숨기기
  advertisements[currentAdIndex].style.transform = 'translateX(-100%)';

  // 다음 광고 표시
  currentAdIndex = (currentAdIndex + 1) % advertisements.length;
  advertisements[currentAdIndex].style.transform = 'translateX(0)';
}, 3000);
let startIndex = 0; // 시작 인덱스 (0부터 시작)

function showTemplates() {
  const templates = document.querySelectorAll('.template');
  templates.forEach((template, index) => {
    const textOptions = [ "한식", "분식", "라면", "탄산음료", "카페음료"];
    const value = startIndex + index;
    template.textContent = textOptions[value % textOptions.length];
  });
}


function showNextTemplates() {
  if (startIndex < 4) {
    startIndex++;
  } else {
    startIndex = 0;
  }
  showTemplates();
}

function showPreviousTemplates() {
  if (startIndex > 0) {
    startIndex--;
  } else {
    startIndex = 4;
  }
  showTemplates();
}

showTemplates();

function checkOnlyOne(element) {
	  
	  const checkboxes 
	      = document.getElementsByName("pay");
	  
	  checkboxes.forEach((cb) => {
	    cb.checked = false;
	  })
	  
	  element.checked = true;
	}
function checkOnlyThree(element) {
  const textbox = document.getElementById('textbox2');
  const checkboxes = document.getElementsByName("pay3");
  
  checkboxes.forEach((cb) => {
    cb.checked = false;
  })
  
  element.checked = true;
  
  if (element.value === 'right') { // 
    textbox.disabled = false; // 텍스트박스를 활성화 상태로 변경
  } else {
    textbox.disabled = true; // 다른 버튼이 선택되었을 때 텍스트박스를 비활성화 상태로 유지
  }
}
</script>
				</font>
			</div>
			<br>
			<textarea placeholder="내용을 입력해주세요."
				style="vertical-align: top; text-align: left;" class="pay-item4"></textarea>
			<div class="pay-item5">
				<button button id="btnid1" onclick="handleClick()">
					주문하기
					</h3>
				</button>
			</div>
		</div>
		<script>
    function doAction2() {
      alert("주문이 완료되었습니다.");
    }  
  </script>
	</div>


	<script>            window.onload = function () {
            loadCartFromSession();
        };
    </script>
</body>
</html>
