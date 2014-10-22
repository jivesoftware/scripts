var viewModel = function (tagTree) {
    var self = this;
    var comUrl = 'https://www.community-url.com';
    self.options = ko.observableArray(tagTree.options);
    self.selectedOption = ko.observable(self.options()[0]);
    self.selectedProduct = ko.observable(null);
    self.items = ko.observableArray([]);
    self.type = ko.observable("");
    self.loading = ko.observable(false);
    self.url = ko.observable('');

    ko.computed(function () {
        var version = self.selectedOption.peek();
        var product = self.selectedProduct();
        var type = self.type();

        if (product) {
            var tags = (version ? version.tags + ',' : '') + (product ? product.tags : '') + (type != "" ? ',' + type : '');
            tags = tags.replace(/[,]{2,}/g, ',').toLowerCase();
            tags = tags.replace(/^,|,$/g, '');
            self.tags = tags;
            self.loading(true);
            self.url('/api/core/v3/contents?filter=tag(' + tags + ')&filter=place(' + comUrl + '/api/core/v3/places/1438)&count=100);
            self.items.removeAll();
        }
    }).extend({ throttle: 1000 });

    ko.computed(function () {
        setTimeout(resizeMe, 1);
        $.ajax({url: self.url(),
          type: "GET", dataType: 'json',
          dataFilter: function (response) { return response.replace(/throw.*;\s*/g, ""); }
        }).done(function (response) {
            self.items.push.apply(self.items, ko.utils.arrayFilter(response.list, function (item) {
                // Ensure each result contain all the tags requested.
                var tagsList = self.tags.split(',');
                for (var i = 0; i < tagsList.length; i++) {
                    var tag = tagsList[i].replace(/^\s+|\s+$/g, '');
                    if (tag != '') {
                        if ($.inArray(tag, item.tags) == -1) {
                            return false;
                        }
                    }
                }
                return true;
            }));

            if (response.links && response.links.next) { self.url(response.links.next);
            } else { self.loading(false); }
            
            setTimeout(resizeMe, 1);
        });
    });
}

ko.applyBindings(new viewModel(downloads));
