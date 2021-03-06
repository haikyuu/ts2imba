import {test, expect} from "vitest"
import {build} from "../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const key = url.pathname.slice(1);

    switch (request.method) {
      case 'PUT':
        await env.MY_BUCKET.put(key, request.body);
        return new Response("Put {key} successfully!");
      case 'GET':
        const object = await env.MY_BUCKET.get(key);

        if (object === null) {
          return new Response('Object Not Found', { status: 404 });
        }

        const headers = new Headers();
        object.writeHttpMetadata(headers);
        headers.set('etag', object.httpEtag);

        return new Response(object.body, {
          headers,
        });
      case 'DELETE':
        await env.MY_BUCKET.delete(key);
        return new Response('Deleted!');

      default:
        return new Response('Method Not Allowed', {
          status: 405,
          headers: {
            Allow: 'PUT, GET, DELETE',
          },
        });
    }
  },
};
'''

let imba-code = '''
export default fetch: do(request, env)
	const url = new URL(request.url)
	const key = url.pathname.slice(1)
	switch request.method
		when "PUT"
			await env.MY_BUCKET.put(key, request.body)
			return new Response("Put {key} successfully!")
		when "GET"
			const object = await env.MY_BUCKET.get(key)
			if object === null
				return new Response("Object Not Found", status: 404)
			const headers = new Headers
			object.writeHttpMetadata headers
			headers.set "etag", object.httpEtag
			return new Response(object.body, headers: headers)
		when "DELETE"
			await env.MY_BUCKET.delete(key)
			return new Response("Deleted!")
		else
			return new Response("Method Not Allowed",
				status: 405
				headers:
					Allow: "PUT, GET, DELETE")
	return

'''
test 'while' do
	const result = await build tsx-code
	console.log result.code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js