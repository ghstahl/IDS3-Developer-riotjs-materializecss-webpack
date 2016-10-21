import RiotControl from 'riotcontrol';
var RiotControlRegistrationMixin  = {

    // init method is a special one which can initialize
    // the mixin when it's loaded to the tag and is not
    // accessible from the tag its mixed in

    // This requires that the riot-lifecycle-mixin is mixed in before this one, as this one requires it to register with it.

    init: function() {
        var self = this;
        self._riotControlMap = new Array()
        console.log('RiotControlRegistrationMixin:init:',self)

        self.registerLifeCycleHandler('mount',function(){
            console.log('RiotControlRegistrationMixin mount: aspnet-user-detail',self._riotControlMap);
            for (var i = 0, len = self._riotControlMap.length; i < len; i++) {
                RiotControl.on(self._riotControlMap[i].evt, self._riotControlMap[i].handler);
            }
        })

        self.registerLifeCycleHandler('unmount',function(){
            console.log('RiotControlRegistrationMixin unmount handler',self._riotControlMap)
            for (var i = 0, len = self._riotControlMap.length; i < len; i++) {
                RiotControl.off(self._riotControlMap[i].evt, self._riotControlMap[i].handler);
            }
        })
    },
    registerEventHandler:function(evt,handler){
        var self = this;
        self._riotControlMap.push({evt:evt,handler:handler});
        return this;
    }
}

if (typeof(module) !== 'undefined') module.exports = RiotControlRegistrationMixin;