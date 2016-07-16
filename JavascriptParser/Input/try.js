try { 
        if(x == "") throw "is empty";
        if(isNaN(x)) throw "is not a number";
    }
    catch(err) {
        message.innerHTML = "Error: " + err + ".";
    }
    finally {
        document.getElementById("demo").value = "";
    }