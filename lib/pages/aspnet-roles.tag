import RiotControl from 'riotcontrol';

<aspnet-roles>
    <ul class="collapsible collection with-header">
        <li class="collection-header"><h4>AspNet Roles</h4></li>
        <li each="{roles}">
            <div class="collapsible-header"><i class="material-icons">mode_edit</i>{ Name }</div>
            <div class="collapsible-body">
                <p>
                    <a onclick={ onRemoveRole }
                       data-message={Name}
                       class="waves-effect waves-light red btn">Remove</a>
                </p>
            </div>
        </li>



        <li >

            <form  class="col s12">

                <div class="row">
                    <div class="input-field col s0">
                        <a id="addRoleButton"
                           disabled={ !isRoleAddable }
                           onclick={onAddRole}
                           class="btn-floating btn-medium waves-effect waves-light "><i class="material-icons">add</i></a>
                    </div>
                    <div class="input-field col s10">
                        <input
                                ref = "r"
                                type="text" class="validate"
                                oninput = { onRoleChange }
                                onchange = { onRoleChange }
                                onkeypress = { onKeyPress }
                                >
                        <label>Add a new role.</label>
                    </div>
                </div>

            </form>

        </li>
    </ul>


    <script>
        var self = this;
        self.roles = []
        self.isRoleAddable = false;
        self.lastRole = null;


        self.onRolesChanged =  function(roles) {
            console.log('roles_changed',roles)
            self.roles = roles;
            self.update();
        }
        self.onRolesCreateAck =  function(data) {
            console.log('aspnet_roles_create_ack',data)
            RiotControl.trigger('aspnet_roles_fetch');
        }
        self.onRolesDeleteAck =  function(data) {
            console.log('aspnet_roles_delete_ack',data)
            RiotControl.trigger('aspnet_roles_fetch');
        }
        self.on('unmount', function() {
            RiotControl.off('aspnet_roles_changed', self.onRolesChanged)
            RiotControl.off('aspnet_roles_create_ack', self.onRolesCreateAck)
            RiotControl.off('aspnet_roles_delete_ack', self.onRolesDeleteAck)
        });

        self.on('mount', function() {
            console.log('mount',this)
            $('.collapsible').collapsible({
                accordion : false // A setting that changes the collapsible behavior to expandable instead of the default accordion style
            });
            RiotControl.on('aspnet_roles_changed', self.onRolesChanged)
            RiotControl.on('aspnet_roles_create_ack', self.onRolesCreateAck)
            RiotControl.on('aspnet_roles_delete_ack', self.onRolesDeleteAck)

            RiotControl.trigger('aspnet_roles_fetch');
            self.calcOnRoleAddable();
        });

        self.onRemoveRole = (e) =>{

            console.log('onRemoveRole',e,e.target.dataset.message)
            RiotControl.trigger('aspnet_roles_delete',  {role:e.target.dataset.message} );
            self.collapseAll();
        }

        self.onAddRole = function() {
            if(self.isRoleAddable == true){
                console.log('onAddRole',self.lastRole)
                RiotControl.trigger('aspnet_roles_create',{
                    role:self.lastRole
                });
                self.lastRole = "";
                self.refs.r.value  = self.lastRole;
                self.calcOnRoleAddable();
            }
        }
        self.calcOnRoleAddable = ()=>{
            if(self.lastRole && self.lastRole.length > 1){
                self.isRoleAddable =  true;
                self.addRoleCallback = self.onAddRole;
            }else{
                self.isRoleAddable =  false;
                self.addRoleCallback = null;
            }
        }
        self.onRoleChange = function(e) {
            console.log('onRoleChange',self.refs.r,self.refs.r.value);
            var roleTerm = self.refs.r.value
            self.lastRole = roleTerm

            self.calcOnRoleAddable();
            console.log(self.isRoleAddable)
        }

        self.onKeyPress = function(e) {
            if(!e)
                e=window.event;
            var keyCode = e.keyCode || e.which;
            console.log('onKeyPress',keyCode,e);
            if(keyCode== 13){
                event.preventDefault();
                if(self.isRoleAddable){
                    self.onAddRole();
                }
                return false;
            }else{
                return true;
            }
        }
        self.collapseAll = () =>{
            $(".collapsible-header").removeClass(function(){
                return "active";
            });
            $(".collapsible").collapsible({accordion: true});
            $(".collapsible").collapsible({accordion: false});
        }
    </script>
</aspnet-roles>