import { isObject } from '../util/index';
import { observe } from '../observe/Observer';
import Watcher from '../observe/Watcher';

/**
 * 对任意对象添加$watch 扩展
 * @param key
 * @param cb
 * @returns {Watcher}
 */
Object.prototype.$watch = function (key, cb) {
  return new Watcher(this, key, cb);
};

/**
 * 将array 转换成for指令
 * @param forTarget
 */
Array.prototype.toForDirector = function (forTarget) {
  for (let i = 0; i < this.length; i++) {
    forTarget.addItem(this[i], i);
  }
  // 监听数据改变事件
  const ob = observe(this);
  const a = this.$watch('arrarchanged', (methodname, args) => {
    switch (methodname) {
      case 'push':
        args.forEach((item) => {
          forTarget.addItem(item, this.indexOf(item));
        });
        break;
      case 'unshift':// 向数组的开头添加一个或更多元素
        // TODO:暂不支持插入
        break;
      case 'shift':// 删除数组的第一个元素
        forTarget.deleteItemWithIndex(0);
        break;
      case 'pop': // 删除数组的最后一个元素
        forTarget.deleteItemWithIndex(this.length);// 这里index 直接写length，因为已经将数据删除过了，而native还没有删除
        break;
      case 'reverse': // 反转数组
      case 'sort':// 对数组进行排序
        forTarget.deleteAllItems();// 先删除所有的数据，然后再重新创建数据。
        for (let i = 0; i < this.length; i++) {
          forTarget.addItem(this[i], i);
        }
        break;
      case 'splice': {
        const startIndex = args[0];
        const count = args[1];
        // const insertedItems = args[2];
        if (count > 0) { // 删除items
          if (startIndex >= 0) { // 从前往后删
            for (let i = 0; i < count; i++) {
              forTarget.deleteItemWithIndex(startIndex);
            }
          } else { // 从后往前删
            // TODO: 暂不支持.
          }
        } else if (count === 0) { // 添加items
          // TODO:插入不支持
        }
        break;
      }
      default:
        break;
    }
  });
  a.addDep(ob.dep);
};


/**
 * 添加元素数据绑定
 * @param obj
 * @param bindExp 绑定到某个属性
 * @param cbName
 * @returns {Watcher}
 */
Object.prototype.addElementBind = function (obj, bindExp, cbName) {
  observe(this);
  // 主要是用来判断哪些属性需要做监听
  Object.keys(this).forEach((key) => {
    if (bindExp.indexOf(key) >= 0) {
      let watchers = obj.__watchers__;
      if (!watchers) {
        watchers = [];
        obj.__watchers__ = watchers;
      }

      let hasW = false;
      watchers.forEach((w) => {
        if (w.expOrFn === key) {
          hasW = true;
        }
      });

      if (!hasW) {
        const watcher = new Watcher(this, key, () => {
          obj[cbName](this);
        });
        watchers.push(watcher);
      }

      // check path
      const value = this[key];
      if (isObject(value)) {
        value.addElementBind(obj, bindExp, cbName);
      }
    }
  });
};

/**
 * 执行绑定表达式(主要是为了解决在表达式中没有添加this，无法访问属性的问题。这个问题其实也可以通过后期编译的方式来解决，类似vue的做法，但是暂时先这样吧。)
 * 这样做可能会有性能问题，但是问题不大。
 * @param expStr 表达式
 * @param selfElement 方法内部this 指针指向的对象
 */
Object.prototype.executeBindExpression = function (expStr, selfElement) {
  let jsStr = 'var dataContext = arguments[0];';
  if (isObject(this)) {
    Object.keys(this).forEach((key) => {
      jsStr += `var ${key}=dataContext.${key};`;
    });
  }
  jsStr += expStr;
  if (!selfElement) { selfElement = this; }
  return (new Function(jsStr)).call(selfElement, this);
};

/**
 * 提供给普通绑定用的，数据源为native数据源
 * @param props
 * @param expStr
 * @returns {*}
 */
Object.prototype.executeBindExpression2 = function (props, expStr) {
  let jsStr = '';
  props.forEach((key) => {
    jsStr += `var ${key}=this.${key};`;
  });
  jsStr += expStr;
  return (new Function(jsStr)).call(this);
};

export function Binding() {
}