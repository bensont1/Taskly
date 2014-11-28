
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

// when a task is saved, send push notifications to people who offered on it
// send congrats notification to person who was selected; send rejection to 
// people who weren't selected
Parse.Cloud.afterSave("Tasks", function(request) {


});

// when an offer is saved, send notification to task owner, telling them
// they have a new offer
Parse.Cloud.afterSave("Offers", function(request) {
	// get user who made the offer
	var offerUser = request.object.get('user');

	// get task owner
	var task = request.object.get('forTask');
	var taskOwner = task.object.get('owner');
	
	// get 
	var userQuery = new Parse.Query(Parse.User);
	pushQuery.equalTo('', 'ios');

	//
	Parse.Push.send({
		where: pushQuery,
		date: {
			alert: "You have a new offer!"
		}
	});


});
