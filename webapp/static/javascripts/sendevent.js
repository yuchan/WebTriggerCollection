function sendEvent() {
    if (window.webkit === undefined) {
    	$.ajax({
    	  type: "POST",
    	  url: "/api/fake",
    	  data: { "name": "checkout" },
    	});
    } else {
		webkit.messageHandlers.observe.postMessage({name: "checkout"});    
    }
}