const express = require('express')
const bodyParser = require('body-parser')
const app = express()
app.use(bodyParser.json())

const port = 3007

app.listen(port, () =>{
    console.log(`Server running on port ${port}`)
})

var aid = 4
var products = [{id: 1, name: "apple", expirationDate: "10/10/2010", quantity: "5 L", price: "5"},
               {id: 2, name: "asparagus", expirationDate: "12/12/2012", quantity: "4 Buc", price: "10"},
               {id: 3, name: "aubergine", expirationDate: "20/08/2020", quantity: "10 Kg", price: "15"},
               {id: 4, name: "avocado", expirationDate: "20/08/2020", quantity: "10 Kg", price: "15"},
               {id: 5, name: "banana", expirationDate: "20/08/2020", quantity: "10 Kg", price: "15"},
               {id: 6, name: "carrot", expirationDate: "20/08/2020", quantity: "10 Kg", price: "15"},
               {id: 7, name: "broccoli", expirationDate: "20/08/2020", quantity: "10 Kg", price: "15"},
               {id: 8, name: "blueberries", expirationDate: "20/08/2020", quantity: "10 Kg", price: "15"},
               {id: 9, name: "cheese", expirationDate: "20/08/2020", quantity: "10 Kg", price: "15"},
               {id: 10, name: "boiled", expirationDate: "20/08/2020", quantity: "10 Kg", price: "15"},
               {id: 11, name: "eggs", expirationDate: "20/08/2020", quantity: "10 Kg", price: "15"},
               {id: 12, name: "bacon", expirationDate: "20/08/2020", quantity: "10 Kg", price: "15"},
               {id: 13, name: "ham", expirationDate: "20/08/2020", quantity: "10 Kg", price: "15"},
               {id: 14, name: "hamburguer", expirationDate: "20/08/2020", quantity: "10 Kg", price: "15"},
               {id: 15, name: "hot-dog", expirationDate: "20/08/2020", quantity: "10 Kg", price: "15"},
               {id: 16, name: "meat", expirationDate: "20/08/2020", quantity: "10 Kg", price: "15"},
               {id: 17, name: "pizza", expirationDate: "20/08/2020", quantity: "10 Kg", price: "15"},
               {id: 18, name: "salmon", expirationDate: "20/08/2020", quantity: "10 Kg", price: "15"},
               {id: 19, name: "salami", expirationDate: "20/08/2020", quantity: "10 Kg", price: "15"},]

app.get('/products', (req, res) =>
{
    res.json(products)
})

app.get('/product/:id', (req, res) =>
{
    const id = parseInt(req.params.id)
    const product = products.find( product => product.id === id )
    res.json(product)
})

app.post('/products', (req, res)=>
{
    const product = req.body
    product.id = aid
    aid +=1
    products.push(product)
    console.log(products)
    res.json(product)
})

app.put('/product/:id', (req,res)=>{
    const product = req.body
    const id = parseInt(req.body.id)
    const index = products.findIndex(product => product.id === id)
    products[index]=product
    products[index].id = parseInt(products[index].id) 
    console.log(products)
    res.json(products[index])
})

app.delete('/product/:id',(req,res)=>{
    const id = parseInt(req.params.id)
    const index = products.findIndex(product => product.id === id)
    products.splice(index,1)
    console.log(products)
    res.json({})
})