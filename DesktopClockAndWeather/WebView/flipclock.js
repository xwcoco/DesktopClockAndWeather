(function (global, factory) {
    typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
    typeof define === 'function' && define.amd ? define(['exports'], factory) :
    (factory((global.clock = {})));
}(this, (function (exports) { 'use strict';

    class DOMBase {
        constructor(config) {
            this.config = config || {};
            this._content = null;
            this.setContent(config.content);
            this.init();
            this.build();
        }

        init() {}

        build() {}

        get content() {
            return this._content;
        }

        setContent(value) {
            let id;
            if (typeof value === 'string') {
                if (value.charAt(0) === '.') {
                    const className = value.slice(1);
                    this._content = window.document.getElementsByClassName(className)[0];
                } else {
                    id = null;
                    if (value.charAt(0) !== '#') {
                        id = value;
                    } else {
                        id = value.slice(1);
                    }
                    this._content = window.document.getElementById(id);
                }
                if (!this._content) {
                    console.log('Can not find container in document with id ' + id);
                }
            }
            // return this;
        }

    }

    class Digit {
        constructor(num, content) {
            this.num = num;
            this.content = content;

            this.build();
        }

        build() {
            this.createNum(this.num);
        }

        createNum(x) {
            let ul = window.document.createElement("ul");
            ul.className = "flip";
            this.ul = ul;
            this.content.appendChild(ul);
            this._beforeDiv = this.createSubNum(ul, x, "flip-clock-before");
            this._activeDiv = this.createSubNum(ul, x, "flip-clock-active");
        }

        createSubNum(ul, x, name) {

            let li = window.document.createElement("li");
            li.className = name;
            ul.appendChild(li);

            let href = window.document.createElement("a");
            href.setAttribute("href", "#");
            li.appendChild(href);

            let up = window.document.createElement("div");
            up.className = "up";
            href.appendChild(up);

            let shadow = window.document.createElement("div");
            shadow.className = "shadow";
            up.appendChild(shadow);

            let inn = window.document.createElement("div");
            inn.className = "inn";
            inn.innerText = x;
            up.appendChild(inn);

            let down = window.document.createElement("div");
            down.className = "down";
            href.appendChild(down);

            let downshadow = window.document.createElement("div");
            downshadow.className = "shadow";
            down.appendChild(downshadow);

            let downinn = window.document.createElement("div");
            downinn.className = "inn";
            downinn.innerText = x;
            down.appendChild(downinn);

            return li;
        }

        set displayText(value) {
            if (value === this.num) return;
            this.num = value;
            this.ul.classList.add("play");

            this._beforeDiv.classList.remove("flip-clock-before");

            this._activeDiv.classList.remove("flip-clock-active");
            this._activeDiv.classList.add("flip-clock-before");

            this.ul.removeChild(this._beforeDiv);
            this._beforeDiv = this._activeDiv;

            this._activeDiv = this.createSubNum(this.ul, value, "flip-clock-active");
        }

    }

    class FlipClock extends DOMBase {

        init() {
            this.mode = this.config.mode || 0;
            this.list = [];
        }

        build() {
            this.content.innerHTML = "";
            this.content.classList.add("flip-clock-wrapper");

            let str = this.getDisplayStr();

            let data = this.convertDigitsToArray(str);

            for (let i = 0; i < data.length; i++) {
                let x = data[i];
                let digit = new Digit(x, this.content);
                this.list.push(digit);
            }

            this.createDividers();

            this.start();
        }

        createDividers() {
            if (this.mode === 4 || this.mode === 5) {
                let div = this.createDivider();
                this.content.insertBefore(div, this.content.childNodes[2]);

                if (this.mode === 4) {
                    div = this.createDivider();
                    this.content.insertBefore(div, this.content.childNodes[5]);
                }
            }
        }

        createDivider() {
            let div = window.document.createElement("span");
            div.className = "flip-clock-divider";
            let up = window.document.createElement("span");
            up.className = "flip-clock-dot top";
            div.appendChild(up);

            let down = window.document.createElement("span");
            down.className = "flip-clock-dot bottom";
            div.appendChild(down);

            return div;
        }

        getDisplayStr() {

            switch (this.mode) {
                case 0:
                    return new Date().Format("ss");
                case 1:
                    return new Date().Format("mm");
                case 2:
                    return new Date().Format("hh");
                case 3:
                    return new Date().Format("dd");
                case 4:
                    return new Date().Format("hhmmss");
                case 5:
                    return new Date().Format("hhmm");
            }
        }

        convertDigitsToArray(str) {
            let data = [];

            str = str.toString();

            for (let x = 0; x < str.length; x++) {
                if (str[x].match(/^\d*$/g)) {
                    data.push(str[x]);
                }
            }

            return data;
        }

        flip() {
            let str = this.getDisplayStr();
            let data = this.convertDigitsToArray(str);
            for (let i = 0; i < this.list.length; i++) {
                let digit = this.list[i];
                digit.displayText = data[i];
            }
        }

        onTimer() {
            this.flip();
        }

        start() {
            this.timer = setInterval(this.onTimer.bind(this), 1000);
        }
    }

    Date.prototype.Format = function (fmt) {
        //author: meizz
        var o = {
            "M+": this.getMonth() + 1, //月份
            "d+": this.getDate(), //日
            "h+": this.getHours(), //小时
            "m+": this.getMinutes(), //分
            "s+": this.getSeconds(), //秒
            "q+": Math.floor((this.getMonth() + 3) / 3), //季度
            "S": this.getMilliseconds() //毫秒
        };
        if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
        for (var k in o) if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, RegExp.$1.length == 1 ? o[k] : ("00" + o[k]).substr(("" + o[k]).length));
        return fmt;
    };

    let createClock = function (id, mode) {
        let config = {
            content: id,
            mode: mode
        };

        let clock = new FlipClock(config);
    };
    // export default eateClock()

    exports.createClock = createClock;

    Object.defineProperty(exports, '__esModule', { value: true });

})));
//# sourceMappingURL=flipclock.js.map
