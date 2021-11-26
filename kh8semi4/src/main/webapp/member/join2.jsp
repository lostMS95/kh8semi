<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String root = request.getContextPath();
%>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<jsp:include page="/template/header.jsp"></jsp:include>
<style>
.notice {
	color: red;
}

.snapsync-form-wrapper input:not([type]), .snapsync-form-wrapper input[type="text"], .snapsync-form-wrapper input[type="password"] {
    width: 100%;
    border: #EBEBEB 1px solid;
    border-radius: 10px;
    padding: 0px 10px;
    font-size: 15px;
    height: 39px;
    line-height: 39px;
}
.snap-sync-btn-submit {
    cursor: pointer;
    background: #191919;
    width: 100%;
    border-radius: 10px;
    color: #FFFFFF;
    margin: 10px 0;
    padding: 15px;
    font-size: 15px;
    font-weight: 600;
    outline: none;
    border: 0;
    display: inline-block;
    text-align: center;
    text-decoration: none;
}
.snapsync-member-nav li ~ li {
    border-left: #CFCFCF 1px solid;
}

.snapsync-member-nav li {
    width: 30.0%;
    text-align: center;
    color: #A5A5A5;
    list-style: none;
    display: inline-block;
}

.snapsync-member-nav {
    padding: 5px 0;
}


a:link { 
color: black; text-decoration: none;
}

a:visited { 
color: black; text-decoration: none;
}}
</style>
<script>
//주소 찾기   	
$(function(){
$(".find-address-btn").click(function(){
    findAddress();
	});

function findAddress(){
    new daum.Postcode({
        oncomplete: function(data) {
            // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
            // 각 주소의 노출 규칙에 따라 주소를 조합한다.
            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
            var addr = ""; // 주소 변수
            //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
            // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
            if (data.userSelectedType === "R") { // 사용자가 도로명 주소를 선택했을 경우
                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                if(data.bname !== "" && /[동|로|가]$/g.test(data.bname)){
                    addr = data.roadAddress + " (" + data.bname + ")";
                }
                else{
                    addr = data.roadAddress;
                }
            } 
            else { // 사용자가 지번 주소를 선택했을 경우(J)
                addr = data.jibunAddress;
            }
            // 우편번호와 주소 정보를 해당 필드에 넣는다.
            
            //$("input[name=postcode]").val(data.zonecode);
            document.querySelector("input[name=address]").value = addr;
            //$("input[name=address]").val(addr);
            // 커서를 상세주소 필드로 이동한다.
            
            //$("input[name=detailAddress]").focus();
        }
    }).open();
};
});
</script>
<script>
	//아이디 중복확인 Ajax
    $(function(){
    	$("input[name=id]").on("blur", function(){
    		var inputId = $("input[name=id]").val();
    		$.ajax({
    			url : "<%=root%>/member/ajax_id_check.kj",
				type : "get",
				data : {//전송 시 첨부할 파라미터 정보
					id : inputId
				},
				success : function(resp) {
					if (resp == "YESICAN") {//사용가능
					} else if (resp == "NONONO") {//사용불가능
						$("input[name=id]").next().text("아이디가 이미 사용중입니다");
					}
				},
				error : function(err) {//통신이 실패했다.
				}
			});
		});
	});
	//핸드폰번호 중복확인 Ajax
    $(function(){
    	$("input[name=phone]").on("blur", function(){
    		var inputPhone = $("input[name=phone]").val();
    		$.ajax({
    			url : "<%=root%>/member/ajax_phone_check.kj",
				type : "get",
				data : {//전송 시 첨부할 파라미터 정보
					phone : inputPhone
				},
				success : function(resp) {
					if (resp == "YESICAN") {//사용가능
					} else if (resp == "NONONO") {//사용불가능
						$("input[name=phone]").next().text("사용중인 휴대폰번호입니다.");
					}
				},
				error : function(err) {//통신이 실패했다.
				}
			});
		});
	});
	//아이디 정규표현식
	$(function() {
		$("input[name=id]").on("input", function() {
			var regex = /^[a-z][a-z0-9-_]{5,19}$/;
			var id = $(this).val();
			var span = $(this).next();
			if (regex.test(id)) {
				span.text("");
			} else {
				span.text("아이디는 6~20자 영문+숫자로 작성하세요");
			}
		});
	});
	//비밀번호 정규표현식
	$(function() {
		$("input[name=pw]").on("input", function() {
			var regex = /^[A-Za-z0-9!@#$\s_-]{8,16}$/;
			var pw = $(this).val();
			var span = $(this).next();
			if (regex.test(pw)) {
				span.text("");
			} else {
				span.text("비밀번호는 8~16자 이내의 영문,숫자,특수문자로 작성하세요");
			}
		});
	});
	//비밀번호 확인
	$(function(){
		$("input[name=pw2]").on("blur",function(){
			var pwInput = $("input[name=pw]").val();
			var pw2Input = $("input[name=pw2]").val();
			var span = $(this).next();
			if (pwInput.length > 0 && pwInput == pw2Input) {
				span.text("");
			} else {
				span.text("비밀번호가 일치하지 않습니다");
			}
		});
	});
	//이름 정규표현식
	$(function() {
		$("input[name=name]").on("input", function() {
			var regex = /^[가-힣]{2,17}$/;
			var name = $(this).val();
			var span = $(this).next();
			if (regex.test(name)) {
				span.text("");
			} else {
				span.text("이름은 한글2~17자 이내로 작성하세요");
			}
		});
	});
	//주소 정규표현식
	$(function() {
		$("input[name=address]").on("input", function() {
			var regex = /^[가-힣\s]+$/;
			var address = $(this).val();
			var span = $(this).next();
			if (regex.test(address)) {
				span.text("");
			} else {
				span.text("다시입력바람");
			}
		});
	});
	//전화번호 정규표현식
	$(function() {
		$("input[name=phone]").on("input", function() {
			var regex = /^[0-9]{2,3}-[0-9]{3,4}-[0-9]{4}$/;
			var phone = $(this).val();
			var span = $(this).next();
			if (regex.test(phone)) {
				span.text("");
			} else {
				span.text("(-)포함  11자리로 작성하세요");
			}
		});
	});
	//이메일 정규표현식
	$(function() {
		$("input[name=email]").on("input",function() {
			var regex = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/;
			var email = $(this).val();
			var span = $(this).next();
			if (regex.test(email)) {
				span.text("");
			} else {
				span.text("이메일 형식이 올바르지 않습니다");
			}
		});
	});
	//생년월일 정규표현식
	$(function() {$("input[name=birth]").on("input",function() {
		var regex = /^(19[0-9][0-9]|20\d{2})-(0[0-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/;
		var birth = $(this).val();
		var span = $(this).next();
		if (regex.test(birth)) {
			span.text("");
		} else {
			span.text("생년월일을 선택하세요");
		}
	});
});				
</script>
  
<form action="<%=root%>/member/join.kj" method="post">
	
	<div class="container-400 container-center">
		<div class="row center">
			<h2>로그인</h2>
		</div>
		
		<div class="snapsync-form-wrapper">
        
        <input id="member_id" name="member_id" fw-filter="isFill" fw-label="아이디" fw-msg="" class="inputTypeText" placeholder="아이디" value="" type="text">
        <input id="member_passwd" name="member_passwd" fw-filter="isFill&amp;isMin[4]&amp;isMax[16]" fw-label="패스워드" fw-msg="" autocomplete="off" value="" type="password" placeholder="비밀번호">
        <input id="check_save_id0" class="snapsync-type-btn-saveid" name="check_save_id" fw-filter="" fw-label="아이디저장" fw-msg="" value="T" type="checkbox">
        <label for="check_save_id0">아이디 저장</label><button class="snap-sync-btn-submit" onclick="MemberAction.login('member_form_3907916616'); return false;">로그인</button>
        <div class="flex">
        <ul class="snapsync-member-nav center">
        	<li><a href="/member/id/find_id.html">아이디 찾기</a></li>
            <li><a href="/member/passwd/find_passwd_info.html">비밀번호 찾기</a></li>
            <li><a href="/member/join.html">회원가입</a></li>
            </ul>
            </div>
        </div>
		
	</div>

</form>

<jsp:include page="/template/footer.jsp"></jsp:include>