viewManager = (function (self, $j) {
   self.case = {
       subject : ko.observable(),       
       content : {
          type : "text/html",
          text : ko.observable()
       },
       type : 'discussion'
       parent: '/api/core/v3/places/23212'
   };

   self.create = function () {
       $j.ajax({
          url: '/api/core/v3/contents',
          type: 'POST',
          contentType: 'application/json',
          data: ko.toJSON(self.case)
       });
   };
   
   return self;
})(viewManager || {}, $j);
