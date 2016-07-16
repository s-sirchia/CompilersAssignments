function clearConsole(){
			document.getElementById("stack").innerHTML ="";
		}

		function operation(operation){
			if(stack.length>1){
				var first = stack.pop();
				var firstInt = parseInt(first);
				if (!(Number.isInteger(firstInt))){
					stack.push(first);
					return;
				}
				var second = stack.pop();
				var secondInt = parseInt(second);
				if (!(Number.isInteger(secondInt))){
					stack.push(second);
					stack.push(first);
					return;
				}
				var total = eval(second+operation+first);
				console.log(second+operation+first);
				console.log(total);
				stack.push(total);
			}
		}

		function topSwitch(){
			if(stack.length>1){
				var first = stack.pop();
				var second = stack.pop();
				stack.push(first);
				stack.push(second);
			}
		}

		function evaluate(){
			var Top = stack.pop();
			switch (Top) {
				case "+":
					operation("+");
					break;
				case "-":
					operation("-");
					break;
				case "s":
					topSwitch();
					break;
				default:
					stack.push(Top);
					break;
			}
		}

		function convertExpression() {
			var string =document.getElementById("Espressione").value;
			string = string.replace(" ","");
			var array = string.split("");
			var lastNumber;
			var lastOperations="";
			for (var i = 0; i < array.length; i++) {
				if (i==0){
					var number = array[i];
					while(!(isNaN(array[i+1]))){
						number += array[i+1];
						i++;
					}
					lastNumber = number;
					stack.push(number);
				}else{
					var number = array[i];
					if(isNaN(number)){
						if (number=="*"){
							var times="";
							while(!(isNaN(array[i+1]))){
								times += array[i+1];
								i++;
							}
							if(lastOperations.indexOf("+") >= 0)
								convertTimes(lastNumber,times);
							else
								convertTimes(stack[stack.length-1],times);

							lastOperations += number;
							continue;
						}
						lastOperations += number;
						stack.push(number);
						continue;
					}
					while(!(isNaN(array[i+1]))){
							number += array[i+1];
							i++;
					}
					lastNumber = number;
					stack.push(number);
					if (!(isNaN(array[i]))){
						stack.push("s");
						evaluate();
						evaluate();
					}
				}
			}
		display();
		document.getElementById("Espressione").value = "";
		}

		function convertTimes(lastNumber,times) {
			var head = stack[stack.length-1];
			for(i =0;i<times-1;i++){
				stack.push(lastNumber);
				stack.push("+");
				evaluate();
			}
		}

		function display(){
			var toPrint = stack.slice().reverse().toString();
			toPrint = toPrint.replace(/,/gi,"<br>");
			document.getElementById("stack").innerHTML =
			"CURRENT STACK<br>" + toPrint;
		}

		function exit(){
			alert("Ok, thanks! Bye!");
			stack = [];
			document.getElementById("stack").innerHTML = "";
			document.getElementById("Comando").value = "";
			return;
		}

		var stack = [];

		function startMachine() {
			clearConsole();
			command = document.getElementById("Comando").value;
			if (command != null) {
				command = command.toLowerCase();
				switch (command) {
					case "e":
						evaluate();
						break;
					case "d":
						display();
						break;
					case "x":
						exit();
						return;
					case "+":
						stack.push(command);
						break;
					case "-":
						stack.push(command);
						break;
					case "s":
						stack.push(command);
						break;
					default:
					{
						if (!(isNaN(command))){
							stack.push(command);
						}
						else{
							document.getElementById("stack").innerHTML =
							"INVALID COMMAND";
						}
					}
				};
			}
			document.getElementById("Comando").value = "";
		}