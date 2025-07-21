import {build} from "../../index"
import * as imbac from 'imba/compiler'

let tsx-code3 = '''
try{
	const a = 2
} catch(error){
	console.log(3)
}
'''
test 'nested_objects 1' do
	const result = await build tsx-code3
	expect(result.code).toMatchSnapshot!
	const out = imbac.compile(result.code, sourceId: 'sth')
	expect(out.js).toBeDefined()



let tsx-code = '''
let a = { "b": { "x": 3, "y": 3 }, d: 4 }
'''
test 'nested_objects 2' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	expect(out.js).toBeDefined()


let tsx-code2 = '''
export default {
	"rate": 14.7645,
	"country": "TR",
	"currency": "TRY",
	"products": {
		"annual": {
			"id": "annual",
			"name": "Yearly",
			"price": 1560,
			"coupons": [],
			"display": {
				"price": "1.560TL",
				"price_usd": "$110",
				"baseline_api_id": "reference",
				"discount_to_baseline": 77,
				"baseline_price_formatted": "570TL",
				"reference_interval_price": "130TL",
				"price_with_baseline_strike": "5̶7̶0̶T̶L̶ 130TL"
			},
			"duration": "year",
			"interval": "month",
			"price_usd": 105.6588438484202,
			"integrations": {
				"stripe": {
					"amount": 156000,
					"currency": "TRY",
					"formatted": "1.560TL"
				}
			},
			"interval_count": 12,
			"price_formatted": "1.560TL"
		},
		"monthly": {
			"id": "monthly",
			"name": "Monthly",
			"price": 260,
			"coupons": [],
			"display": {
				"price": "260TL",
				"price_usd": "$18",
				"baseline_api_id": "reference",
				"discount_to_baseline": 54,
				"baseline_price_formatted": "570TL",
				"reference_interval_price": "260TL",
				"price_with_baseline_strike": "5̶7̶0̶T̶L̶ 260TL"
			},
			"duration": "month",
			"interval": "month",
			"price_usd": 17.60980730807003,
			"integrations": {
				"stripe": {
					"amount": 26000,
					"currency": "TRY",
					"formatted": "260TL"
				}
			},
			"interval_count": 1,
			"price_formatted": "260TL"
		},
		"bootcamp": {
			"id": "bootcamp",
			"price": 3500,
			"coupons": [],
			"display": {
				"price": "3.500TL",
				"price_usd": "$210",
				"baseline_api_id": "bootcamp",
				"discount_to_baseline": 0,
				"baseline_price_formatted": "3.500TL",
				"reference_interval_price": "3.500TL",
				"price_with_baseline_strike": "3.500TL"
			},
			"interval": "month",
			"price_usd": 202.56188699708946,
			"integrations": {
				"stripe": {
					"amount": 350000,
					"currency": "TRY",
					"formatted": "3.500TL"
				}
			},
			"interval_count": 1,
			"price_formatted": "3.500TL"
		},
		"semester": {
			"id": "semester",
			"name": "Half-year",
			"price": 960,
			"coupons": [
				{
					"id": 485,
					"sum": null,
					"uid": "ua4aPkAq",
					"code": "ua4aPkAq-2990ec42",
					"limit": 1,
					"plans": [
						"6"
					],
					"title": "24 hour discount",
					"users": null,
					"groups": null,
					"percent": 0.75,
					"created_at": "2022-06-16T13:16:02.825Z",
					"expires_at": "2022-06-17T13:16:02.824Z",
					"description": "Nice course progress by ua4aPkAq - gtailwind"
				}
			],
			"display": {
				"price": "960TL",
				"price_usd": "$66",
				"baseline_api_id": "reference",
				"discount_to_baseline": 71,
				"baseline_price_formatted": "570TL",
				"reference_interval_price": "160TL",
				"price_with_baseline_strike": "5̶7̶0̶T̶L̶ 160TL"
			},
			"duration": "half-year",
			"interval": "month",
			"price_usd": 65.0208269836432,
			"integrations": {
				"stripe": {
					"amount": 96000,
					"currency": "TRY",
					"formatted": "960TL"
				}
			},
			"interval_count": 6,
			"price_formatted": "960TL"
		},
		"reference": {
			"id": "reference",
			"price": 570,
			"coupons": [],
			"display": {
				"price": "570TL",
				"price_usd": "$39",
				"baseline_api_id": "reference",
				"discount_to_baseline": 0,
				"baseline_price_formatted": "570TL",
				"reference_interval_price": "570TL",
				"price_with_baseline_strike": "570TL"
			},
			"interval": "month",
			"price_usd": 38.60611602153815,
			"integrations": {
				"stripe": {
					"amount": 57000,
					"currency": "TRY",
					"formatted": "570TL"
				}
			},
			"interval_count": 1,
			"price_formatted": "570TL"
		}
	},
	"currency_symbol": "TL"
}
'''
test 'nested_objects_advanced 3' do
	const result = await build tsx-code2
	expect(result.code).toMatchSnapshot!
	const out = imbac.compile(result.code, sourceId: 'sth')
	expect(out.js).toBeDefined()
