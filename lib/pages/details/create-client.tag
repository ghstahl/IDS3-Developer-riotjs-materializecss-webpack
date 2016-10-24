import Sortable from '../../js/Sortable.min.js';
import './simple-input.tag'

<create-client>

    <ul class="collapsible" data-collapsible="accordion">
        <li>
            <div class="collapsible-header"><i class="material-icons">add</i>Create New Client...</div>
            <div class="collapsible-body">
                <div class="container">
                    <div class="row">
                        <form class="col s12" >
                            <div class="row">
                                <div class="input-field col s6">

                                    <i class="material-icons prefix">account_circle</i>
                                    <input
                                            type="text" class="validate"
                                            oninput = { onRChange }
                                            onchange = { onRChange }
                                            onkeypress = { onKeyPress }
                                            name='r' >
                                    <label >Friendly Client Name</label>
                                </div>
                                <div class="input-field col s6" id="flowPickerContainer">
                                    <i class="material-icons prefix">timeline</i>
                                    <select id="selectFlow">
                                        <option  value="-1" disabled selected>Add New Flow...</option>
                                        <option  each="{availableFlows}" value="{Name}"
                                                 onChange={this.onSelectChanged}
                                                 data-message={Name}>{Name}</option>
                                    </select>
                                    <label>Flow Type</label>
                                </div>
                            </div>
                            <div class="row">
                                <div class="input-field col s6">
                                    <ul class="collection with-header" id="assignedScopeDragTarget">
                                        <div class="collection-header">
                                            <h5>Assigned Scopes</h5>
                                            <span>Drag granted scopes here...</span>
                                            <span><i class="material-icons secondary-content">arrow_downward</i></span>
                                        </div>

                                        <li each={_itemsAssignedScopes}
                                            data-item={name}
                                            class="collection-item">
                                            <span><i class="material-icons">assignment_turned_in</i></span>
                                            <span>{name}</span>
                                            <a onclick={onRemoveScopeItem}
                                               class="waves-effect secondary-content">
                                                Remove</a>
                                        </li>
                                    </ul>
                                </div>

                                <div class="input-field col s6">
                                    <ul class="collection with-header" id="grantedScopeDragSource">
                                        <div class="collection-header">
                                            <h5>Granted Scopes</h5>
                                            Drag granted scopes from here...
                                        </div>
                                        <li each={opts.granted_scopes} data-item="{name}" class="collection-item">
                                            <span class="my-handle"><i class="material-icons">assignment_return</i></span>
                                            <span>{name}</span>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </li>
    </ul>

    <a id="submitBtn"
       disabled={ !validated }
       onclick={onSubmit}
       class="btn-floating btn-medium waves-effect waves-light ">
        <i class="material-icons">add</i>
    </a>

    <style>
        .collapsible li.disabled .collapsible-header:hover {
            cursor: default;
        }
        .sortable-ghost {
            opacity: .3;
            background: #f60;
        }
        .my-handle {
            cursor: move;
            cursor: -webkit-grabbing;
        }
        .ignore-elements{}
        #assignedScopeDragTarget  {
            min-height: 150px
        }
        .dropdown-content {
            min-width: 200px; /* Changed this to accomodate content width */
        }
    </style>

    <script>
        var self = this;
        self.mixin("opts-mixin");
        self.validated = false;
        self._itemsAssignedScopes = []
        self.onRemoveScopeItem = (e) =>{
            console.log('onRemoveScopeItem',e.item.name)
            var result = self._itemsAssignedScopes.filter(function( item ) {
                return item.name != e.item.name;
            });
            self._itemsAssignedScopes = result;
            self.update()
        }
        self.onSubmit = () =>{

        }

        self.doValidationCheck = function() {
            var friendlyOk = self.lastR.length > 4;
            self.validated = friendlyOk
        }

        self.onRChange = function(e) {
            var rValue = self.r.value
            self.lastR = rValue
            self.doValidationCheck();
        }

        self.onKeyPress = function(e) {
            if(!e)
                e=window.event;
            var keyCode = e.keyCode || e.which;
            console.log('onKeyPress',keyCode,e);
            if(keyCode== 13){
                event.preventDefault();
                if(self.validated){
                    self.onSubmit();
                }
                return false;
            }else{
                return true;
            }
        }

        self.on('mount',function() {

            Sortable.create(self.grantedScopeDragSource, {
//                handle: ".my-handle",
                filter: ".ignore-elements",
                group: {
                    name: 'scopes',
                    pull: 'clone',
                    put: false
                },
                sort:false
            });

            Sortable.create(self.assignedScopeDragTarget, {
                filter: ".ignore-elements",
                group: {
                    name: 'scopes',
                    pull: false
                },
                sort:false,
                onAdd: function (evt) {
                    var el = evt.item;
                    var newItem = evt.item.attributes["data-item"].value;
                    console.log(newItem);

                    // is it in our backing array
                    var item = self._itemsAssignedScopes.find(x => x.name === newItem);
                    if (item) {
                        console.log("This item already exists");
                    }
                    else {
                        self._itemsAssignedScopes.push({ name: newItem });
                    }
                    self.emptyUL2(self.assignedScopeDragTarget);
                    var temp = self._itemsAssignedScopes;
                    self._itemsAssignedScopes = [];
                    self.update();
                    self._itemsAssignedScopes = temp;
                    self.update();
                }
            });

            self.result = null;
            var q = riot.route.query();
            console.log('on mount: identityserver-developer-detail',q);
            RiotControl.trigger('developer-scopes-get');
            RiotControl.trigger('developer-clients-page',{Page:9,PagingState:null});
            $('.collapsible').collapsible({
                accordion : false // A setting that changes the collapsible behavior to expandable instead of the default accordion style
            });
            $('select').material_select();
        })
    </script>
</create-client>