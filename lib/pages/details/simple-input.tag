<simple-input>

    <i class="material-icons prefix">{opts.material_icon}</i>
    <input
            type="text"
            class="validate"
            oninput = { onRChange }
            onchange = { onRChange }
            onkeypress = { onKeyPress }
            name='r' >
    <label>{opts.label}</label>

    <script>
        var self = this;
        self.mixin("opts-mixin");

        riot.observable(self)  // going to emit events

    </script>
</simple-input>
